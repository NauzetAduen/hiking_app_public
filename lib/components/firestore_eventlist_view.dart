import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/pages/detailed_views/detailed_event.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:hiking_app/utils/date_helper.dart';
import 'package:provider/provider.dart';

class FireStoreEventListView extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  FireStoreEventListView({this.documents});

  @override
  _FireStoreEventListViewState createState() => _FireStoreEventListViewState();
}

class _FireStoreEventListViewState extends State<FireStoreEventListView> {
  String message = "";
  bool showOnlyParticipating = false;
  bool showOldEvents = false;
  String uid = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    uid = Provider.of<FirebaseUser>(context).uid;
    return ListView.builder(
      itemCount: widget.documents.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: _getIconParticipant(showOnlyParticipating),
                onPressed: () {
                  setState(() {
                    showOnlyParticipating = !showOnlyParticipating;
                    //Write
                  });
                },
              ),
              IconButton(
                icon: _getIconOldEvents(showOldEvents),
                onPressed: () {
                  setState(() {
                    showOldEvents = !showOldEvents;
                    //Write
                  });
                },
              ),
              Container(
                width: 250,
                child: TextFormField(
                  controller: controller,
                  onFieldSubmitted: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                  style: Styles.loginTextStyle,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          message = "";
                          controller.text = message;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Styles.green,
                      ),
                    ),
                    errorStyle: Styles.errorLoginTextStyle,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Styles.pinkGradient)),
                    labelText: "Search",
                    labelStyle: Styles.loginTitle,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
            ],
          );
        }
        index -= 1;
        Event event = Event.fromJson(widget.documents[index].data);
        if (showOnlyParticipating) {
          if (!event.participantsList.contains(uid)) {
            return SizedBox();
          }
        }
        if (showOldEvents) {
          if (!event.date.isAfter(DateTime.now())) {
            return SizedBox();
          }
        }
        if (message.length > 0) {
          //if is not in any of those
          if (!event.eventName.contains(message) &&
              !event.description.contains(message) &&
              !event.creatorName.contains(message)) {
            return SizedBox();
          }
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
              borderRadius: BorderRadius.circular(15),
              color: Styles.backGroundColor,
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                    gradient: Styles.tileGradient,
                    borderRadius: BorderRadius.circular(15)),
                child: Builder(
                  builder: (context) => ListTile(
                      onTap: () => _navigateToDetailedEvent(
                          context, widget.documents[index].documentID),
                      title: Text(event.eventName, style: Styles.listTileTitle),
                      subtitle: Text(
                        "${DateHelper.timeLeft(event.date)}",
                        style: Styles.eventDate,
                      ),
                      trailing: _buildIconButton(
                          event, context, widget.documents[index].documentID)),
                ),
              )),
        );
      },
    );
  }

  void _navigateToDetailedEvent(BuildContext context, String documentID) {
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => DetailedEvent(documentID)));
  }

  IconButton _buildIconButton(Event e, context, String documentID) {
    DocumentReference reference =
        Firestore.instance.collection("events").document(documentID);
    // return Icon(
    //   e.participantsList.contains(Provider.of<FirebaseUser>(context).uid)? FontAwesomeIcons.userCheck: FontAwesomeIcons.userTimes,
    //   color:e.participantsList.contains(Provider.of<FirebaseUser>(context).uid)? Styles.green: Colors.grey,
    // );
    if (e.participantsList.contains(uid)) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.userCheck,
          color: Styles.green,
        ),
        onPressed: () {
          if (e.date.isBefore(DateTime.now())) {
            Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("You can't leave and old event"),
   
          duration: Duration(milliseconds: 4000),
        ));
          } else {
            leaveEvent(reference);
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.userTimes,
          color: Colors.grey,
        ),
        onPressed: () {
          if (e.date.isBefore(DateTime.now())) {
            Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("You can't join and old event"),
   
          duration: Duration(milliseconds: 4000),
        ));
          } else {
            joinEvent(reference);
          }
        },
      );
    }
  }

  Future leaveEvent(DocumentReference reference) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<dynamic> list = snapshot.data['participantsList'];
      List<String> newList = _getNewListWOUser(list);
      await transaction
          .update(snapshot.reference, {"participantsList": newList});
    });
  }

  Future joinEvent(DocumentReference reference) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);
      List<dynamic> list = snapshot.data['participantsList'];
      List<String> newList = _getNewListWithUser(list);
      await transaction
          .update(snapshot.reference, {"participantsList": newList});
    });
  }

  Icon _getIconOldEvents(bool showOldEvents) {
    if (showOldEvents) {
      return Icon(
        FontAwesomeIcons.calendarTimes,
        color: Styles.green,
      );
    }
    return Icon(
      FontAwesomeIcons.calendarTimes,
      color: Colors.grey,
    );
  }

  Icon _getIconParticipant(bool isParticipating) {
    if (isParticipating) {
      return Icon(
        FontAwesomeIcons.userCheck,
        color: Styles.green,
      );
    }
    return Icon(
      FontAwesomeIcons.userTimes,
      color: Colors.grey,
    );
  }

  List<String> _getNewListWithUser(List<dynamic> list) {
    List<String> newList = [];
    list.forEach((element) {
      newList.add(element.toString());
    });
    newList.add(uid);
    return newList;
  }

  List<String> _getNewListWOUser(List<dynamic> list) {
    List<String> newList = [];
    list.forEach((element) {
      newList.add(element.toString());
    });
    newList.remove(uid);
    return newList;
  }
}

enum datesEnum { EVERYTHING, NEXTWEEK, NEXTMONTH }
