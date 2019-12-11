import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:hiking_app/utils/validator_helper.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _resetFormKey = GlobalKey<FormState>();
  String _email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LeadingAppbar(Text("")),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Styles.backGroundColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
            child: Form(
              key: _resetFormKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    onSaved: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                    keyboardType: TextInputType.emailAddress,
                     decoration: _getDecoration("Email"),
                    style: Styles.loginTextStyle,
                    validator: ValidatorHelper.emailValidator,
                  ),
                  SizedBox(height: 20,),
                  Builder(
                builder: (context) =>GradientButton(
              increaseWidthBy: 70,
              callback: () {
                if (_resetFormKey.currentState.validate()) {
                  _resetFormKey.currentState.save();
                  FirebaseAuth.instance.sendPasswordResetEmail(
                    email: _email
                  ).then((onValue){
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Email send to your account"),
                      duration: Duration(milliseconds: 4000),
                      ));
                      Navigator.pop(context);
                  }).catchError((onError){
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("$onError"),
                      duration: Duration(milliseconds: 4000),
                      ));
                  });
                }
              },
              gradient: Styles.buttonGradient,
              child: Text("Reset Password", style: Styles.titleTextStyle),
            ),)
                  
                ],
              ),
            ),
          ),
        ));
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
}
