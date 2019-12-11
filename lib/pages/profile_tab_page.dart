import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiking_app/components/firestore_personal_eventlist_view.dart';
import 'package:hiking_app/components/firestore_personal_traillist_view.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String defaultURL = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  List<Trail> userTrails;
  List<Event> userEvents;
  String uid;
  static int maxAverage = 5;



  @override
  Widget build(BuildContext context) {
    uid = Provider.of<FirebaseUser>(context).uid;

    return ListView(
      
      children: <Widget>[
         _buildTitle("User information"),
         _buildUserInfo(),
         _buildTitle("My trails"),
         _getMyTrails(context, uid),
         _buildTitle("My Events"),
         _getMyEvents(context, uid)
      ],
    );
  }

  Widget _buildUserInfo() {
    int createdByUser = 0;
    int favorited = 0;
    
    QuerySnapshot trails = Provider.of<QuerySnapshot>(context);
    trails.documents.forEach((t){
      Trail tempTrail = Trail.fromJsonWithMap(t.data);
      if (tempTrail.userID == uid){
        createdByUser++;
      }
      if(tempTrail.likedBy.contains(uid)){
        favorited++;
      }
    });
    
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                  gradient: Styles.tileGradient,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: <Widget>[
                        Flexible(child: _buildName()),
                        Flexible(child: _buildCircularAvatar()),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildTotalInfoExpanded(
                          "Trails created", createdByUser.toString()),
                      _buildTotalInfoExpanded("Trails favorited", favorited.toString()),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: <Widget>[
                  //     _buildTotalInfoExpanded(
                  //         "Events created", totalEvents.toString()),
                  //     _buildTotalInfoExpanded("Events finished", "133"),
                  //   ],
                  // ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            )));
  }

  Expanded _buildTotalInfoExpanded(String title, String total) {
    return Expanded(
        child: Column(
      children: <Widget>[
        Text(
          "$title",
          style: Styles.userInfoTitlesTS,
        ),
        Text(
          "$total",
          style: Styles.userInfoNumbersTS,
        )
      ],
    ));
  }

  Widget _buildCircularAvatar() {
    var user = Provider.of<FirebaseUser>(context);
    String photoUrl = user.photoUrl != null? user.photoUrl : defaultURL;
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 33,
      backgroundImage: NetworkImage(
          photoUrl),
    );
  }


  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20),
      child: Text(
        title,
        style: Styles.titleList,
      ),
    );
  }


  Widget _buildName() {
    var user = Provider.of<FirebaseUser>(context);
    String name = (user.displayName != null && user.displayName.isNotEmpty) ? user.displayName : user.email;
    return Text(
      name,
      style: Styles.userInfoNameTS,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
  
  Widget _getMyEvents(BuildContext context, String username) {
    return StreamBuilder(
      stream: Firestore.instance.collection("events").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(
            // child: CircularProgressIndicator(),
            child: SizedBox(),
          );
          return FireStorePersonalEventListView(documents: snapshot.data.documents, creatorId: uid);
        
      },
    );
  }
  Widget _getMyTrails(BuildContext context, String username) {
    return StreamBuilder(
      stream: Firestore.instance.collection("trails").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(
            // child: CircularProgressIndicator(),
            child: SizedBox(),
          );
        return FireStorePersonalTrailListView(documents: snapshot.data.documents, userId: uid);
      },
    );
  }


}
