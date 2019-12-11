import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hiking_app/components/firestore_trail_selector_view.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:hiking_app/utils/validator_helper.dart';
import 'package:provider/provider.dart';

class NewEvent extends StatefulWidget {
  final List<Trail> trailList;

  const NewEvent(this.trailList);
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  Event newEvent = Event.blank();
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  TimeOfDay time;
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  TextEditingController _trailNameController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  TextEditingController _timeController = TextEditingController();
  var trailName;

  @override
  void initState() {
    super.initState();
    //trailName = widget.trailList.first.trailName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeadingAppbar(
          Text("New Event", style: Styles.appbarTextStyleWithLetterSpacing)),
      body: Container(
        color: Styles.backGroundColor,
        child: _buildForm(),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: TextFormField(
              validator: ValidatorHelper.eventNameValidator,
              controller: _eventNameController,
              style: Styles.dropdownStyle,
              decoration: _getDecoration("Event"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: TextFormField(
                validator: ValidatorHelper.eventDescriptionValidator,
                controller: _eventDescriptionController,
                style: Styles.dropdownStyle,
                decoration: _getDecoration("Description")),
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: TextFormField(
                      validator: ValidatorHelper.eventTrailNameValidator,
                      controller: _trailNameController,
                      style: Styles.dropdownStyle,
                      enabled: false),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GradientButton(
                    increaseWidthBy: 70,
                    callback: () => _pickTrail(),
                    gradient: Styles.googleSignButtonGradient,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Pick trail", style: Styles.googleButtonTextStyle,),
                        Icon(FontAwesomeIcons.route, size: 20, color: Colors.black,)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          _dateInfoBuilder(),
          GradientButton(
            increaseWidthBy: 80,
            callback: () {
              _validateForm();
            },
            gradient: Styles.buttonGradient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Create Event", style: Styles.titleTextStyle),
                Icon(
                  FontAwesomeIcons.calendarPlus,
                  size: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _setDate() async {
    date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    setState(() {
      _dateController.text = "${date.day}/${date.month}/${date.year}";
    });
  }

  void _pickTrail() async{
    final result = await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => FireStoreTrailSelectorView()));
    
    if(result != null){
      setState(() {
        _trailNameController.text = result;
      });
      
    }
        

  }

  void _setTime() async {
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _timeController.text = _getTime(time);
    });
  }

  String _getTime(TimeOfDay time) {
    String minute = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    String hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    return "$hour:$minute";
  }

  Widget _buildDateInfo() {
    return Container(
      width: 150,
      child: TextFormField(
        validator: ValidatorHelper.eventDateValidator,
        style: Styles.loginTitle,
        controller: _dateController,
        enabled: false,
        decoration: _getDecorationDropDown(),
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Container(
      width: 150,
      child: TextFormField(
        validator: ValidatorHelper.eventTimeValidator,
        style: Styles.loginTitle,
        controller: _timeController,
        enabled: false,
        decoration: _getDecorationDropDown(),
      ),
    );
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

  InputDecoration _getDecorationDropDown() {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.white,
        )),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Styles.pinkGradient)),
        alignLabelWithHint: false,
        disabledBorder: null);
  }

  Widget _dateInfoBuilder() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GradientButton(
                increaseWidthBy: 55,
                callback: () {
                  _setDate();
                },
                gradient: Styles.tileGradient,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Set Date", style: Styles.titleTextStyle),
                    Icon(
                      FontAwesomeIcons.calendarCheck,
                      size: 20,
                    ),
                  ],
                ),
              ),
              _buildDateInfo(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GradientButton(
                increaseWidthBy: 55,
                callback: () {
                  _setTime();
                },
                gradient: Styles.tileGradient,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Set Time", style: Styles.titleTextStyle),
                    Icon(
                      FontAwesomeIcons.clock,
                      size: 20,
                    ),
                  ],
                ),
              ),
              _buildTimeInfo(),
            ],
          ),
        )
      ],
    );
  }

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _addEvent();
      Navigator.pop(context);
    }
  }

  void _addEvent() {
    
    Event newEvent = Event(
        eventName: _eventNameController.text,
        description: _eventDescriptionController.text,
        date: _buildTime(),
        trailName: _trailNameController.text,
        creatorID: Provider.of<FirebaseUser>(context).uid,
        creatorName: _getCreatorName(),
        participantsList: [Provider.of<FirebaseUser>(context).uid]);

    Firestore.instance.collection("events").add(newEvent.toJson());
  }

  String _getCreatorName(){
    if (Provider.of<FirebaseUser>(context).displayName != null) return Provider.of<FirebaseUser>(context).displayName;
    if (Provider.of<FirebaseUser>(context).email != null) return Provider.of<FirebaseUser>(context).email;
    return "Offline user";
  }

  DateTime _buildTime() {
    var eventTime =
        DateTime.utc(date.year, date.month, date.day, time.hour, time.minute);
    return eventTime;
  }
}
