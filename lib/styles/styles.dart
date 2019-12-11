import 'package:flutter/material.dart';

class Styles {
  // Gradient's colors
  static final Color green = Color(0xff84E0A1);


  // AppBar's TextStyle
  static final TextStyle appbarTextStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Montserrat');
  static final TextStyle appbarTextStyleWithLetterSpacing = TextStyle(
      letterSpacing: 10,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: 'Montserrat');

  //titles style
  static final TextStyle dataTextStyle =
      TextStyle(fontFamily: 'Montserrat', fontSize: 15);
  static final TextStyle titleTextStyle = TextStyle(
      fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle titleTextStyleLarge = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold);

  static final TextStyle participantsLargeNunmber = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 35,
      color: Colors.orange,
      fontWeight: FontWeight.bold);
  static final TextStyle creatorLarge = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 25,
      color: Colors.orange,
      fontWeight: FontWeight.bold);

  //Forms
  static final TextStyle labelStyle = TextStyle(
      color: Colors.orange,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      fontSize: 15);

  //New styles
  static final Color grayGradient =Color(0xFF937FF0);
  static final Color pinkGradient =Color(0xFFFB75B2);
  static final Color purpleGradient = Color(0xFF937FF0);

  static final Color backGroundColor = Color(0xFF3D476A);
  static final LinearGradient buttonGradient =
      LinearGradient(colors: [Color(0xFF937FF0), Color(0xFFFB75B2)]);
  static final LinearGradient tileGradient = LinearGradient(colors: [Color(0xFF545C81), Color(0xFF3D476A), ]);
  static final LinearGradient userInfoGradient = LinearGradient(colors: [purpleGradient, pinkGradient]);
  static final LinearGradient googleSignButtonGradient = LinearGradient(colors: [Colors.white, Colors.blue]);

  //listTile
  static final TextStyle listTileTitle = TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'Montserrat' );

  //google button textstyle
  static final TextStyle googleButtonTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize:16);
  //title ontop of listtiles in profile
  static final TextStyle titleList = TextStyle(letterSpacing: 8, color: green, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'SpaceMono');


  //userinfo
  static final TextStyle userInfoNameTS = TextStyle(color: pinkGradient, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Montserrat');
  static final TextStyle userInfoTitlesTS = TextStyle(color: Colors.white70, fontSize: 15, fontFamily: 'SpaceMono');
  static final TextStyle userInfoNumbersTS = TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'SpaceMono');
  static final TextStyle loginTitle = TextStyle(color: Colors.white70, fontSize: 18, fontFamily: 'SpaceMono', fontWeight: FontWeight.bold);


  //login style
  static final TextStyle loginTextStyle = TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Montserrat',);
  static final TextStyle errorLoginTextStyle = TextStyle(color: Colors.yellow, fontSize: 15, fontFamily: 'Montserrat',);

  //dropdown
  static final TextStyle dropdownStyle = TextStyle(color: pinkGradient, fontFamily: 'SpaceMono', fontSize: 20, );

  //eventlist, date style
  static final TextStyle eventDate = TextStyle(color: Colors.white, fontFamily: 'Monserrat', fontSize: 15);


  //alert dialog
  static final TextStyle alertTitle = TextStyle(color: Colors.white, fontFamily: 'Monserrat', fontSize: 17, fontWeight: FontWeight.bold);
  static final TextStyle alertContent = TextStyle(color: Colors.white70, fontFamily: 'Monserrat', fontSize: 15, );


  //Calendar styles
  static final TextStyle headerTextStyle = TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Monserrat');
  static final TextStyle todayTextStyle = TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Monserrat', fontWeight: FontWeight.bold);
  static final TextStyle normalDayTextStyle = TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Monserrat');
  static final TextStyle weekEndDayTextStyle = TextStyle(color: pinkGradient, fontSize: 18, fontFamily: 'Monserrat');
  static final TextStyle offDaysTextStyle = TextStyle(color: Colors.white30, fontSize: 14, fontFamily: 'Monserrat');
  static final TextStyle daysNamesTextStyle = TextStyle(color: green, fontSize: 18, fontFamily: 'Monserrat');
  

}
