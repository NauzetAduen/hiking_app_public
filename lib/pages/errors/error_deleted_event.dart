import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hiking_app/styles/styles.dart';

class ErrorDeletedObject extends StatelessWidget {
  final String objectDeleted;

  const ErrorDeletedObject(this.objectDeleted);
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () => Navigator.pop(context));
    return Scaffold(
      backgroundColor: Styles.backGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text("The creator of this $objectDeleted just deleted it ...",
                  style: Styles.dropdownStyle, textAlign: TextAlign.center,)),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator(
            backgroundColor: Styles.pinkGradient,
            valueColor: AlwaysStoppedAnimation(Styles.purpleGradient),
          ),
        ],
      ),
    );
  }
}
