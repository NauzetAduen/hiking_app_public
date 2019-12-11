import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/home_page.dart';
import 'pages/errors/default_page.dart';
import 'pages/login_pages/login_page.dart';

class HikingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          stream: FirebaseAuth.instance.onAuthStateChanged,
        ),
        StreamProvider<QuerySnapshot>.value(
          stream: Firestore.instance.collection("trails").snapshots(),
        ),

      ],
      child: MaterialApp(
        title: 'HikingApp',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return DefaultPage();
            if (snapshot.hasData) return HomePage();
            return LoginPage();
          },
        ),
      ),
    );
  }
}

