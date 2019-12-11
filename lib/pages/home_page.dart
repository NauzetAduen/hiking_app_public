import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiking_app/components/custom_appbar.dart';
import 'package:hiking_app/models/event.dart';
import 'package:hiking_app/models/trail.dart';
import 'package:hiking_app/pages/calendar_page.dart';
import 'package:hiking_app/pages/event_list_page.dart';
import 'package:hiking_app/pages/map_trails_page.dart';
import 'package:hiking_app/pages/new_views/new_event.dart';
import 'package:hiking_app/pages/new_views/new_trail.dart';
import 'package:hiking_app/pages/profile_tab_page.dart';
import 'package:hiking_app/pages/trail_list_page.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import 'errors/default_page.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Trail> trailList;
  List<Event> eventList;
 


  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _getAppBar(_currentIndex),
      body: Container(
          decoration: BoxDecoration(color: Styles.backGroundColor),
          child: _getTab(_currentIndex)),
      bottomNavigationBar: _getNavBar(),
      floatingActionButton: _getFav(_currentIndex),
    );
  }

  BottomNavigationBar _getNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (value) => setState(() => _currentIndex = value),
      currentIndex: _currentIndex, //current
      backgroundColor: Styles.backGroundColor,
      elevation: 0,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.white70,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.home),title: Text("Profile"),),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.mapSigns),title: Text("Trails"),),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.directions),title: Text("Map"),),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.calendar),title: Text("Events"),),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.calendarAlt),title: Text("Calendar"),),
      ],
    );
  }

  Widget _getTab(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return ProfilePage();
      case 1:
        return TrailListPage();
      case 2:
        return MapTrailPage();
      case 3:
        return EventListPage();
      case 4:
        return CalendarPage();
      default:
        return DefaultPage();
    }
  }

  Widget _getFav(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return null;
      case 1:
        return  CircularGradientButton(
          gradient: Styles.buttonGradient,
          callback: _newTrail,
            child: Icon(FontAwesomeIcons.plus),
        );
      case 2:
        return null;
      case 3: case 4:
        return CircularGradientButton(
          gradient: Styles.buttonGradient,
          callback: _newEvent,
            child: Icon(FontAwesomeIcons.calendarCheck),
        );
      default:
        return null;
    }
  }

  void _newTrail() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewTrail()));
  }

  void _newEvent() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEvent(trailList)));
  }

  CustomAppBar _getAppBar(int currentIndex) {
    String message = "";
    switch (_currentIndex) {
      case 0:
        message = "Hiking App";
        break;
      case 1:
        message = "Trails List";
        break;
      case 2:
        message = "Trails Map";
        break;
      case 3:
        message = "Events List";
        break;
      case 4:
        message = "Calendar";
        break;
      default:
        break;
    }
    return CustomAppBar(Text(
      message.toUpperCase(),
      style: Styles.appbarTextStyleWithLetterSpacing,

    ));
  }

}
