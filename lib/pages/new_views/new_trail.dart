import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:hiking_app/utils/haversine.dart';
import 'package:hiking_app/utils/marker_helper.dart';
import 'package:hiking_app/utils/validator_helper.dart';
import 'package:provider/provider.dart';

import 'new_trail_map.dart';

class NewTrail extends StatefulWidget {
  @override
  _NewTrailState createState() => _NewTrailState();
}

class _NewTrailState extends State<NewTrail> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController difficultyController = TextEditingController();

  Trail newTrail = Trail.blank();
  int difficulty = 3;
  List<DropdownMenuItem<int>> listDropDown = _populateListDropDown();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LeadingAppbar(
            Text("New Trail", style: Styles.appbarTextStyleWithLetterSpacing)),
        body: Container(
          color: Styles.backGroundColor,
          child: ListView(
            children: <Widget>[
              _buildForm(),
              _buildRowButtons(),
            ],
          ),
        ));
  }

  Widget _buildRowButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GradientButton(
            increaseWidthBy: 60,
            callback: () {
              _navigateToCreateMapPage();
            },
            gradient: Styles.tileGradient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Create trail", style: Styles.titleTextStyle),
                Icon(FontAwesomeIcons.mapMarked),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GradientButton(
            increaseWidthBy: 20,
            callback: () {
              _validateForm();
              
            },
            gradient: Styles.buttonGradient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Save", style: Styles.titleTextStyle),
                Icon(FontAwesomeIcons.checkCircle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: TextFormField(
              validator: ValidatorHelper.trailNameValidator,
                style: Styles.dropdownStyle,
                controller: nameController,
                decoration: _getDecoration("Trail's name")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: TextFormField(
              validator: ValidatorHelper.trailDescriptionValidator,
                style: Styles.dropdownStyle,
                controller: descController,
                maxLines: 4,
                decoration: _getDecoration("Trail's description")),
          ),
          _getDistanceDifRow(),
        ],
    ));
  }

  Row _getDistanceDifRow() {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  validator: ValidatorHelper.trailDistanceValidator,
                  controller: distanceController,
                  enabled: false,
                  style: Styles.dropdownStyle,
                  decoration: _getDecoration("Distance"),
                ),
              ),
            ),
            SizedBox(
              width: 25,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child:  _getDifficultColumn(),
                ),
              ),
          ],
        );
  }

  Column _getDifficultColumn() {
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Difficulty", style: Styles.loginTitle,),
                      Container(
                        alignment: Alignment.center,
                        child: DropdownButton(
                          iconEnabledColor: Styles.green,
                          icon: Icon(Icons.arrow_drop_down_circle),
                            value: difficulty,
                            items: listDropDown,
                            onChanged: (value) {
                              setState(() {
                                difficulty = value;
                              }); 
                            }
                                
                        ),
                      ),
                    ],
                  );
  }

  void _navigateToCreateMapPage() async {
    final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewTrailMap()))
        as Set<Marker>;
    if (result != null) {
      newTrail.markers = MarkerHelper.setToMap(result);
      newTrail.distanceInMeters = Haversine.calculateDistance(result);
      distanceController.text = newTrail.distanceInMeters.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }


  static List<DropdownMenuItem<int>> _populateListDropDown() {
    List<DropdownMenuItem<int>> list = [];
    for (int i = 1; i<=5; i++) {
      list.add(DropdownMenuItem(
        child: Text("$i", style: Styles.dropdownStyle,),value: i,
      ));
    }
    return list;
   
  }

  InputDecoration _getDecoration(String labelText) {
    return InputDecoration(
      errorStyle: Styles.errorLoginTextStyle,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white,
      )),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Styles.pinkGradient)),
      labelText: labelText,
      labelStyle: Styles.loginTitle,
      alignLabelWithHint: true,
    );
  }

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _addTrail();
      Navigator.pop(context);
    }
  }

  void _addTrail(){
    Trail finalTrail = Trail(
      trailName: nameController.text,
      userID: Provider.of<FirebaseUser>(context).uid,
      userName: _getUserName(),
      distanceInMeters: double.parse(distanceController.text),
      description: descController.text,
      dificulty: difficulty,
      likes: 1,
      markers: newTrail.markers,
      votesList: [],
      likedBy: [Provider.of<FirebaseUser>(context).uid]
    );
    Firestore.instance.collection("trails").add(finalTrail.toJson());

  }

  String _getUserName(){
    if (Provider.of<FirebaseUser>(context).displayName != null && Provider.of<FirebaseUser>(context).displayName.isNotEmpty)
      return Provider.of<FirebaseUser>(context).displayName;
    return Provider.of<FirebaseUser>(context).email;
  }

}
