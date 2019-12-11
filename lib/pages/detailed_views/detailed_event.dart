import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/pages/errors/default_page.dart';
import 'package:hiking_app/pages/errors/error_deleted_event.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:provider/provider.dart';

import 'edit_event.dart';


class DetailedEvent extends StatefulWidget {
  final String documentID;
  DetailedEvent(this.documentID);

  @override
  _DetailedEventState createState() => _DetailedEventState();
}

class _DetailedEventState extends State<DetailedEvent> {
  bool wasCreatedByUser, isParticipating;
  String userName;
  Event e;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("events")
            .document(widget.documentID)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return DefaultPage();
              break;
            case ConnectionState.done:
            case ConnectionState.active:
              if (snapshot.data.data == null) {
                return ErrorDeletedObject("Event");
              } else {
                e = Event.fromJson(snapshot.data.data);
              }

              userName = Provider.of<FirebaseUser>(context).uid;
              wasCreatedByUser = (userName == e.creatorID);
              isParticipating = e.participantsList.contains(userName);
              return Scaffold(
                  appBar: LeadingAppbar(
                      Text("${e.eventName}", style: Styles.appbarTextStyle)),
                  body: Container(
                    width: double.infinity,
                    color: Styles.backGroundColor,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        _buildDate(),
                        _buildTrailName(),
                        _buildParticipantsAndCreator(),
                        _buildDescription(),
                        _showParticipateButton(),
                        _showDeleteEditEventButton(),
                      ],
                    ),
                  ));
              break;
          }
          return DefaultPage();
        });
  }

  Widget _buildDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Text(
            "${e.date.day}/${e.date.month}/${e.date.year}",
            style: Styles.loginTitle,
            textAlign: TextAlign.center,
          ),
          Text(
            _getTime(TimeOfDay.fromDateTime(e.date)),
            style: Styles.loginTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getTime(TimeOfDay time) {
    String minute = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    String hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    return "$hour:$minute";
  }

  Widget _buildTrailName() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Text(
            "Trail",
            style: Styles.userInfoNameTS,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "${e.trailName}",
              style: Styles.loginTitle,
            ),
          ),
        ],
      ),
      // child: RaisedButton(
      //   onPressed: () => _navigateToDetailedTrail(widget.event.trail),
      //   child: Text("${widget.event.trail.trailName}"),
      // ),
    );
  }

  Widget _buildParticipantsAndCreator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "Participants",
                style: Styles.userInfoNameTS,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "${e.participantsList.length}",
                  style: Styles.loginTitle,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 50,
          ),
          Column(
            children: <Widget>[
              Text(
                "Creator",
                style: Styles.userInfoNameTS,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "${e.creatorName}",
                  overflow: TextOverflow.ellipsis,
                  style: Styles.loginTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Text(
            "Event description",
            style: Styles.userInfoNameTS,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "${e.description}",
              textAlign: TextAlign.justify,
              style: Styles.loginTitle,
            ),
          )
        ],
      ),
    );
  }

  // void _navigateToDetailedTrail(Trail trail) {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => DetailedTrail(trail)));
  // }

  Widget _showParticipateButton() {
    if (e.date.isBefore(DateTime.now())) return SizedBox();
    if (!isParticipating) {
      return GradientButton(
        increaseWidthBy: 15,
        callback: _participateEvent,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Join"),
                Icon(
                  FontAwesomeIcons.userPlus,
                  size: 20,
                ),
              ],
            )),
        gradient: Styles.buttonGradient,
      );
    } else {
      return GradientButton(
        increaseWidthBy: 15,
        callback: _participateEvent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Leave"),
              Icon(
                FontAwesomeIcons.userMinus,
                size: 20,
              ),
            ],
          ),
        ),
        gradient: Styles.tileGradient,
      );
    }
  }

  Future _participateEvent() async {
    DocumentReference reference =
        Firestore.instance.collection("events").document(widget.documentID);

    if (isParticipating)
      _leaveEvent(reference);
    else
      _joinEvent(reference);
  }

  Future _leaveEvent(DocumentReference reference) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<dynamic> list = snapshot.data['participantsList'];
      List<String> newList = _getNewListWOUser(list);
      await transaction
          .update(snapshot.reference, {"participantsList": newList});
    });
  }

  List<String> _getNewListWOUser(List<dynamic> list) {
    List<String> newList = [];
    list.forEach((element) {
      newList.add(element.toString());
    });
    newList.remove(userName);
    return newList;
  }

  List<String> _getNewListWithUser(List<dynamic> list) {
    List<String> newList = [];
    list.forEach((element) {
      newList.add(element.toString());
    });
    newList.add(userName);
    return newList;
  }

  void _joinEvent(DocumentReference reference) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<dynamic> list = snapshot.data['participantsList'];
      List<String> newList = _getNewListWithUser(list);
      await transaction
          .update(snapshot.reference, {"participantsList": newList});
    });
  }

  Widget _showDeleteEditEventButton() {
    if (wasCreatedByUser)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.solidEdit),
              onPressed: () => _goToEditEvent(),
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.solidTrashAlt),
              onPressed: () => _showDeleteDialog(),
            ),
          ],
        ),
      );
    return SizedBox();
  }

  void _goToEditEvent() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditEvent(e, widget.documentID)));
  }

  void _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Styles.backGroundColor,
            title: Text(
              e.eventName,
              style: Styles.alertTitle,
            ),
            content: Text(
              "Do you wan't to delete this event?",
              style: Styles.alertContent,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: _deleteEvent,
                child: Text(
                  "Yes",
                  style: Styles.alertTitle,
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("No", style: Styles.alertTitle),
              ),
            ],
          );
        });
  }


  void _deleteEvent() {
    Firestore.instance
        .collection("events")
        .document(widget.documentID)
        .delete();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
