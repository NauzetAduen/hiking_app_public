import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as range;

import 'leading_appbar.dart';

class FireStoreTrailSelectorView extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  FireStoreTrailSelectorView({this.documents});

  @override
  _FireStoreTrailSelectorViewState createState() =>
      _FireStoreTrailSelectorViewState();
}

class _FireStoreTrailSelectorViewState
    extends State<FireStoreTrailSelectorView> {
  bool showOnlyFavorited = false;
  int minValueFilter = 1;
  int maxValueFilter = 5;
  String message = "";
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: LeadingAppbar(
        Text("Pick a trail", style: Styles.appbarTextStyleWithLetterSpacing)
      ),
      body: Container(
        color: Styles.backGroundColor,
        child: StreamBuilder(
          stream: Firestore.instance.collection("trails").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Container(
        child: ListView.builder(
      itemCount: snapshot.data.documents.length + 1,
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
                icon: Icon(
                  FontAwesomeIcons.slidersH,
                  color: Styles.green,
                ),
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
        Trail trail = Trail.fromJsonWithMap(snapshot.data.documents[index].data);

        if (showOnlyFavorited) {
          if (!trail.likedBy.contains(Provider.of<FirebaseUser>(context).uid)) {
            return SizedBox();
          }
        }
        if (trail.dificulty < minValueFilter ||
            trail.dificulty > maxValueFilter) {
          return SizedBox();
        }
        if (message.length > 0) {
          //if is not in any of those
          if (!trail.trailName.contains(message) &&
              !trail.description.contains(message) &&
              !trail.userName.contains(message)) {
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
                  onTap: () => Navigator.pop(context, trail.trailName ),
                  title: Text(trail.trailName, style: Styles.listTileTitle),
                  subtitle: Text("Difficulty: ${trail.dificulty.toString()}"),
                ),
              ),
            ));
      },
    ));
         }
        )),
    );
  }

  _showSlider() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Styles.backGroundColor,
            title: Text(
              "Difficulty",
              style: Styles.loginTitle,
            ),
            content: Container(
              width: 300,
              height: 25,
              child: range.RangeSlider(
                valueIndicatorMaxDecimals: 0,
                showValueIndicator: true,
                divisions: 5,
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
}
