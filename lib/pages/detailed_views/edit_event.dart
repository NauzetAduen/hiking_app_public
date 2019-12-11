import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hiking_app/components/firestore_trail_selector_view.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:hiking_app/utils/validator_helper.dart';

class EditEvent extends StatefulWidget {
  final Event eventToModify;
  final String documentID;
  // final List<Trail> trailList;

  const EditEvent(this.eventToModify, this.documentID);
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  Event newEvent = Event.blank();
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  TimeOfDay time;
  List<DropdownMenuItem<String>> listDropDown;
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  TextEditingController _trailNameController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  TextEditingController _timeController = TextEditingController();
  var trailName;

  @override
  void initState() {
    super.initState();
    _populateTextFields();
    date = widget.eventToModify.date;
    time = TimeOfDay.fromDateTime(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeadingAppbar(Text("Editing ${widget.eventToModify.eventName}",
          style: Styles.appbarTextStyle)),
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
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          //   child: Container(
          //     child: DropdownButtonFormField(
          //       hint: Text(
          //         "Select Trail",
          //         style: Styles.loginTitle,
          //       ),
          //       decoration: _getDecorationDropDown(),
          //       items: listDropDown,
          //       value: trailName,
          //       onChanged: (value) {
          //         setState(() {
          //           trailName = value;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          _dateInfoBuilder(),
          GradientButton(
            increaseWidthBy: 80,
            callback: () {
              _validateForm();
              _updateEvent();
              Navigator.pop(context);
            },
            gradient: Styles.buttonGradient,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Edit Event", style: Styles.titleTextStyle),
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
  void _pickTrail() async{
    final result = await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => FireStoreTrailSelectorView()));
    
    if(result != null){
      setState(() {
        _trailNameController.text = result;
      });
      
    }
        

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
    }
  }

  void _updateEvent() {
    Event newEvent = Event(
        eventName: _eventNameController.text,
        description: _eventDescriptionController.text,
        date: _buildTime(),
        trailName: _trailNameController.text,
        creatorID: widget.eventToModify.creatorID,
        creatorName: widget.eventToModify.creatorName,
        participantsList: widget.eventToModify.participantsList);

    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection("events").document(widget.documentID);
      DocumentSnapshot snapshot = await transaction.get(reference);
      await transaction.update(snapshot.reference, {
        "eventName": newEvent.eventName,
        "description": newEvent.description,
        "trailName": newEvent.trailName,
        "date": newEvent.date.toIso8601String(),
      });
    });
  }

  DateTime _buildTime() {
    DateTime eventTime =
        DateTime.utc(date.year, date.month, date.day, time.hour, time.minute);
    return eventTime;
  }

  void _populateTextFields() {
    _eventNameController.text = widget.eventToModify.eventName;
    _eventDescriptionController.text = widget.eventToModify.description;
    _trailNameController.text = widget.eventToModify.trailName;


    _dateController.text = _getStringDateFromEventDate();
    _timeController.text = _getStringTimeFromEventDate();
  }

  String _getStringDateFromEventDate() {
    return "${widget.eventToModify.date.day}/${widget.eventToModify.date.month}/${widget.eventToModify.date.year}";
  }

  String _getStringTimeFromEventDate() {
    return _getTime(TimeOfDay.fromDateTime(widget.eventToModify.date));
  }
}
