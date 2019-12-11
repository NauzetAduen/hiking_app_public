import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiking_app/components/custom_google_map.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/models/vote.dart';
import 'package:hiking_app/pages/errors/default_page.dart';
import 'package:hiking_app/pages/errors/error_deleted_event.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'edit_trail.dart';



class DetailedTrail extends StatefulWidget {
  final String documentID;
  DetailedTrail(this.documentID);
  @override
  _DetailedTrailState createState() => _DetailedTrailState();
}

class _DetailedTrailState extends State<DetailedTrail> {
  LatLng startPosition;
    List<LatLng> _points = [];
    List<Polyline> _polygons = [];
    List<Marker> _markers = [];
    Trail t =Trail.blank();

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("trails")
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
              if (snapshot.data.data == null)
                return ErrorDeletedObject("Trail");
              else {
                t = Trail.fromJsonWithMap(snapshot.data.data);
                startPosition = _getFirstPosition(t);
                _points = _getPositions(t);
                _polygons = <Polyline>[
                  Polyline(
                    patterns: [
                      PatternItem.dot,
                    ],
                    geodesic: true,
                    // width: 3,

                    jointType: JointType.round,
                    points: _points,
                    color: Styles.purpleGradient,
                    polylineId: PolylineId("polyID_1"),
                  )
                ];
                _markers = _getMarkers(_points);
              }
              return Scaffold(
                  appBar: LeadingAppbar(Text("${t.trailName}".toUpperCase(),
                      style: Styles.appbarTextStyle)),
                  body: Container(
                    color: Styles.backGroundColor,
                    child: ListView(
                      // physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: CustomGoogleMap(
                              _polygons,
                              _markers,
                              startPosition,
                              18
                              ),

                          height: 300,
                          width: double.infinity,
                        ),
                        _getFavRate(t, context),
                        TrailDescriptionContainer("Description", t.description),
                        TrailDiffDistContainer(t.dificulty, t.distanceInMeters),
                        TrailVotesFavContainer(_getAverage(t), t.likedBy.length),
                        _showDeleteEditEventButton(t),
                      ],
                    ),
                  ));
          }
          return DefaultPage();
        });
  }
  String _getAverage(Trail t) {
    if (t.votesList.length == 0) return "0.0";

    int totalAmount = 0;

    t.votesList.forEach((vote) {
      totalAmount += vote['vote'];
    });

    return (totalAmount / t.votesList.length).toStringAsFixed(1);
  }

  LatLng _getFirstPosition(Trail t) {
    return LatLng(
      t.markers['0']['latitude'],
      t.markers['0']['longitude'],
    );
  }
  List<LatLng> _getPositions(Trail t){
    List<LatLng> list = [];
    for (int i = 0; i< t.markers.length; i++){
      list.add(LatLng(t.markers['$i']['latitude'], t.markers['$i']['longitude']));
    }
    return list;
  }
  List<Marker> _getMarkers(List<LatLng> positions){
    List<Marker> list = [];
    int index =0;
    positions.forEach( (position){
      list.add(Marker(
        icon: _getIcon(index == 0 ||index == positions.length - 1),
      markerId: MarkerId("${list.length}"),
      position: position));
      index++;
    });
    return list;
  }
  BitmapDescriptor _getIcon(bool isFirstOrLast){
    if (isFirstOrLast){
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    // return BitmapDescriptor.fromAsset(assetName);

  }
  bool _isFavoritedByUser(Trail trail, BuildContext context){
    return trail.likedBy.contains(Provider.of<FirebaseUser>(context).uid);
  }

  int _getUserRate(Trail t, BuildContext context){
    int voteFound = 0;
    t.votesList.forEach((vote){
      if (vote['userId'] == Provider.of<FirebaseUser>(context).uid){
        voteFound = vote['vote'];
      }
    });
    return voteFound;
  }
  Widget _getFavRate(Trail t, BuildContext context){

    double rating = _getUserRate(t, context).toDouble();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: _isFavoritedByUser(t, context)
              ? Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                )
              : Icon(
                  FontAwesomeIcons.heartBroken,
                  color: Colors.grey,
                ),
          onPressed: () {
            _updateFav();
          },
        ),
        SmoothStarRating(
          allowHalfRating: false,
          onRatingChanged: (newRate) {
              rating = newRate;
            _updateRatings(rating);
          },
          starCount: 5,
          rating: rating,
          color: Colors.yellow,
          borderColor: Colors.orangeAccent,
        )
      ],
    );
  }

  _updateRatings(double rating){
    List<Map<String,dynamic>> newList = t.votesList;

    Map<String,dynamic> elementToRemove;
    newList.forEach((element){
      if (element['userId'] == Provider.of<FirebaseUser>(context).uid){
        elementToRemove = element;
      }
      
    });
      if (elementToRemove != null){
        newList.remove(elementToRemove);
      }


    newList.add(Vote(userId: Provider.of<FirebaseUser>(context).uid, vote: rating.toInt()).toJson());
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection("trails").document(widget.documentID);
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.update(snapshot.reference, {
        "votesList": newList,
      });
    });
  }

  _updateFav(){
    List<String> newLikedList = t.likedBy;
    if (newLikedList.contains(Provider.of<FirebaseUser>(context).uid))
      newLikedList.remove(Provider.of<FirebaseUser>(context).uid);
    else
      newLikedList.add(Provider.of<FirebaseUser>(context).uid);
    
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection("trails").document(widget.documentID);
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.update(snapshot.reference, {
        "likedBy": newLikedList,
      });
    });
  }
  Widget _showDeleteEditEventButton(Trail t) {
    if (t.userID == Provider.of<FirebaseUser>(context).uid)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.solidEdit),
              onPressed: () => _goToEditTrail(),
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
  _goToEditTrail(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTrail(t, widget.documentID)));
  }
  _showDeleteDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Styles.backGroundColor,
            title: Text(
              t.trailName,
              style: Styles.alertTitle,
              overflow: TextOverflow.ellipsis,
            ),
            content: Text(
              "Do you wan't to delete this trail?",
              style: Styles.alertContent,
              overflow: TextOverflow.ellipsis,
            ),
            actions: <Widget>[
              FlatButton(
                 onPressed: _deleteTrail,
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
  void _deleteTrail() {
    Firestore.instance
        .collection("trails")
        .document(widget.documentID)
        .delete();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class TrailDescriptionContainer extends StatelessWidget {
  final String title;
  final String data;
  TrailDescriptionContainer(this.title, this.data);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
          ),
          child: Text(
            title,
            style: Styles.userInfoTitlesTS,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            data,
            style: Styles.userInfoNumbersTS,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class TrailDiffDistContainer extends StatelessWidget {
  final int difficulty;
  final double distance;
  TrailDiffDistContainer(this.difficulty, this.distance);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Dificulty",
                  style: Styles.userInfoTitlesTS,
                ),
                Text(
                  "${difficulty.toString()}",
                  style: Styles.userInfoNumbersTS,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Distance", style: Styles.userInfoTitlesTS),
                Text(
                  "${distance.toStringAsFixed(1)} metters",
                  style: Styles.userInfoNumbersTS,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrailVotesFavContainer extends StatelessWidget {
  final String average;
  final int likes;

  TrailVotesFavContainer(this.average, this.likes);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Likes",
                  style: Styles.userInfoTitlesTS,
                ),
                Text(
                  "${likes.toString()}",
                  style: Styles.userInfoNumbersTS,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Average", style: Styles.userInfoTitlesTS),
                Text(
                  average,
                  style: Styles.userInfoNumbersTS,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}