import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/pages/detailed_views/detailed_trail.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class FireStorePersonalTrailListView extends StatelessWidget{
  final List<DocumentSnapshot> documents;
  final String userId;
  FireStorePersonalTrailListView({this.documents, this.userId});
  static int maxAverage = 5;

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> myDocs = [];
    for (var doc in documents) {
      if (Trail.fromJsonWithMap(doc.data).userID == Provider.of<FirebaseUser>(context).uid){
        myDocs.add(doc);
      }
    }
    if (myDocs.isEmpty) return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text("You have not created any trails.", style: Styles.listTileTitle,),
    );
    return ListView.builder(
      // physics: AlwaysScrollableScrollPhysics(),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: myDocs.length,
      itemBuilder: (BuildContext context, int index){
        Trail trail = Trail.fromJsonWithMap(myDocs[index].data);
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
            child: ListTile(
                onTap: () => _navigateToDetailedTrailist(myDocs[index].documentID, context),
                title: Text(trail.trailName, style: Styles.listTileTitle),
                //subtitle: Text("Dificulty: ${trail.dificulty.toString()}"),
                trailing: CircularPercentIndicator(
                  lineWidth: 3,
                  progressColor: _getColor(_getAverageDouble(trail)),
                  radius: 45,
                  animationDuration: 3000,
                  animation: true,
                  center: Text(
                    _getAverageString(trail),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  percent: _getPercent(trail),
                ))),
      ),
    );
      },

    );
  }


  String _getAverageString(Trail trail) {
    return _getAverageDouble(trail).toStringAsFixed(1);
  }

  double _getAverageDouble(Trail trail) {
    if (trail.votesList.length == 0) return 0;
    int totalAmount=0;
    trail.votesList.forEach((vote){
       totalAmount += vote['vote'];
    });

    return (totalAmount / trail.votesList.length);
  }
  double _getPercent(Trail trail) {
    return _getAverageDouble(trail)/maxAverage;
  }
  Color _getColor(double average) {
    // return Colors.pinkAccent;
    if (average > 3.5) return Styles.pinkGradient;
    return Styles.grayGradient;
  }


  void _navigateToDetailedTrailist(String documentId,BuildContext context){
     Navigator.push(context,
         CupertinoPageRoute(builder: (context) => DetailedTrail(documentId)));

  }

  
}