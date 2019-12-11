import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/pages/detailed_views/detailed_event.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:hiking_app/utils/date_helper.dart';

class FireStorePersonalEventListView extends StatelessWidget{
  final List<DocumentSnapshot> documents;
  final String creatorId;
  FireStorePersonalEventListView({this.documents, this.creatorId});

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> myDocs = [];
    for (var doc in documents) {
      if ( Event.fromJson(doc.data).creatorID == creatorId){
        myDocs.add(doc);
      }
    }
    if (myDocs.isEmpty) return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text("You have not created any events.", style: Styles.listTileTitle,),
    );
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: myDocs.length,
      itemBuilder: (BuildContext context, int index){
        Event event = Event.fromJson(myDocs[index].data);
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
              onTap: () => _navigateToDetailedEvent(event,myDocs[index].documentID, context),
              title: Text(event.eventName, style: Styles.listTileTitle),
              subtitle: _buildDate(event.date),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[Text(event.participantsList.length.toString(),
                  style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'SpaceMono')),
                  SizedBox(width: 10,),
                Icon(FontAwesomeIcons.userCheck, color: Colors.white,size:15,)
              ]),
          ),
        )));
      },

    );
  }
   void _navigateToDetailedEvent(Event event,String documentId, BuildContext context) {
     Navigator.push(context,
         CupertinoPageRoute(builder: (context) => DetailedEvent(documentId)));
   }

  Text _buildDate(DateTime date) {
    return Text(
      "${DateHelper.timeLeft(date)}",
      style: TextStyle(color: Colors.white70),
    );
  }
}