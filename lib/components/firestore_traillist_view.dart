import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/pages/detailed_views/detailed_trail.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as range;

class FireStoreTrailListView extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  FireStoreTrailListView({this.documents});

  @override
  _FireStoreTrailListViewState createState() => _FireStoreTrailListViewState();
}

class _FireStoreTrailListViewState extends State<FireStoreTrailListView> {
  bool showOnlyFavorited = false;
  int minValueFilter = 1;
  int maxValueFilter = 5;
  String message = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: _getIconFavorited(),
                onPressed: () {
                  setState(() {
                    showOnlyFavorited = !showOnlyFavorited;
                  });
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.slidersH, color: Styles.green,),
                onPressed: () => _showSlider(),
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
                      icon: Icon(Icons.close, color: Styles.green,),
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
        Trail trail = Trail.fromJsonWithMap(widget.documents[index].data);

        if (showOnlyFavorited) {
          if (!trail.likedBy.contains(Provider.of<FirebaseUser>(context).uid)) {
            return SizedBox();
          }
        }
        if (trail.dificulty < minValueFilter ||
            trail.dificulty > maxValueFilter) {
          return SizedBox();
        }
        if (message.length > 0){
          //if is not in any of those
          if (!trail.trailName.contains(message) && !trail.description.contains(message) && !trail.userName.contains(message)){
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
                child: ListTile(
                    onTap: () => _navigateToDetailedTrail(
                        context, widget.documents[index].documentID),
                    title: Text(trail.trailName, style: Styles.listTileTitle),
                    subtitle: Text("Difficulty: ${trail.dificulty.toString()}"),
                    trailing: IconButton(
                      icon: Icon(FontAwesomeIcons.solidHeart),
                      color: _buildColor(trail, context),
                      onPressed: () {
                        _updateFav(
                            trail, context, widget.documents[index].documentID);
                      },
                    )),
              ),
            ));
      },
    );
  }

  _showSlider() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Styles.backGroundColor,
            title: Text("Difficulty", style: Styles.loginTitle,),
            content: Container(
              width: 300,
              height: 25,
              child: range.RangeSlider(
                valueIndicatorMaxDecimals: 0,
                showValueIndicator: true,
                divisions: 4,
                lowerValue: minValueFilter.toDouble(),
                min: 1,
                upperValue: maxValueFilter.toDouble(),
                max: 5,
                onChanged: (min, max) {
                  setState(() {
                    minValueFilter = min.toInt();
                    maxValueFilter = max.toInt();
                  });
                },
              ),
            ),
          );
        });
  }

  Icon _getIconFavorited() {
    if (showOnlyFavorited) {
      return Icon(
        FontAwesomeIcons.solidHeart,
        color: Styles.green,
      );
    }
    return Icon(
      FontAwesomeIcons.solidHeart,
      color: Colors.grey,
    );
  }

  Color _buildColor(Trail trail, BuildContext context) {
    if (trail.likedBy.contains(Provider.of<FirebaseUser>(context).uid))
      return Colors.red;
    return Colors.grey;
  }

  void _navigateToDetailedTrail(BuildContext context, String documentID) {
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => DetailedTrail(documentID)));
  }

  _updateFav(Trail t, BuildContext context, String documentId) {
    List<String> newLikedList = t.likedBy;
    if (newLikedList.contains(Provider.of<FirebaseUser>(context).uid))
      newLikedList.remove(Provider.of<FirebaseUser>(context).uid);
    else
      newLikedList.add(Provider.of<FirebaseUser>(context).uid);

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection("trails").document(documentId);
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.update(snapshot.reference, {
        "likedBy": newLikedList,
      });
    });
  }
}
