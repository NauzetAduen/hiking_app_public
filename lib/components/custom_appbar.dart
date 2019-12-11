import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(this.title);
  @override
  final Widget title;
  @override
  final Color backgroundColor = Styles.backGroundColor;
  @override
  final bool centerTitle = true;
  @override
  final double elevation = 0;

  @override
  final List<Widget> actions = <Widget>[
    PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
              value: "Sign out",
              child: ListTile(
                title: Text("Sign out"),
                onTap: () => FirebaseAuth.instance.signOut(),
              )),
        ];
      },
    ),
  ];
}