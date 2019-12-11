import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:hiking_app/models/event.dart' as myEvent;
import 'package:hiking_app/styles/styles.dart';
import 'package:provider/provider.dart';

class FireStoreEventCalendarview extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  FireStoreEventCalendarview({this.documents});
  @override
  _FireStoreEventCalendarviewState createState() =>
      _FireStoreEventCalendarviewState();
}

class _FireStoreEventCalendarviewState
    extends State<FireStoreEventCalendarview> {
  DateTime _selectedDay;
  EventList<Event> markedDateMap = new EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    _selectedDay = DateTime.now();
    super.initState();
  }

  _updateMap() {
    markedDateMap.clear();
    widget.documents.forEach((doc) {
      myEvent.Event tempEvent = myEvent.Event.fromJson(doc.data);
      if (tempEvent.participantsList
          .contains(Provider.of<FirebaseUser>(context).uid)) {
        Event event = Event(
            date: tempEvent.date, icon: null, title: tempEvent.eventName);
        markedDateMap.add(
            DateTime(
                tempEvent.date.year, tempEvent.date.month, tempEvent.date.day),
            event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateMap();
    return Container(
      color: Styles.backGroundColor,
      child: CalendarCarousel(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _selectedDay = date);
        },
        markedDatesMap: markedDateMap,
        selectedDateTime: _selectedDay,
        daysHaveCircularBorder: true,
        selectedDayTextStyle: Styles.todayTextStyle, 
         selectedDayButtonColor: Styles.pinkGradient, 
         selectedDayBorderColor: Styles.pinkGradient,
          todayBorderColor: Colors.white30,
        todayButtonColor: Colors.white30,
        todayTextStyle: Styles.todayTextStyle, 
        daysTextStyle: Styles.normalDayTextStyle,
        headerTextStyle: Styles.headerTextStyle,
        weekendTextStyle: Styles.weekEndDayTextStyle, 

        nextDaysTextStyle: Styles.offDaysTextStyle, 
        prevDaysTextStyle: Styles.offDaysTextStyle, 
        weekdayTextStyle: Styles.daysNamesTextStyle, 
        iconColor: Styles.pinkGradient, //botones para pasar dem es

        markedDateIconMaxShown: 1,
        markedDateWidget: _getIcon,
        firstDayOfWeek: 1,
      ),
    );
  }
  Widget _getIcon = Padding(padding: EdgeInsets.symmetric(horizontal: 2),
  child:Container(color: Colors.white, height: 5.0, width: 5.0));
  
}
