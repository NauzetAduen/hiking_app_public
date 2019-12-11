import 'package:flutter/material.dart';
import 'package:hiking_app/styles/styles.dart';

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backGroundColor,
      body: Center(child: CircularProgressIndicator(
        backgroundColor: Styles.pinkGradient,
        valueColor: AlwaysStoppedAnimation (Styles.purpleGradient),
      ),)
    );
  }
}