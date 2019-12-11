import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hiking_app/utils/validator_helper.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newPasswordRepeatedeController =
      TextEditingController();
  FocusNode _newEmailFocusNode = FocusNode();
  FocusNode _newPasswordFocusNode = FocusNode();
  FocusNode _newPasswordRepeatedFocusNode = FocusNode();
  String _newEmail = "";
  String _newPassword = "";

  final _formNewUser = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeadingAppbar(Text("")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Styles.backGroundColor),
        child: Form(
          key: _formNewUser,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Create an account!',
                  style: Styles.titleList,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 75, vertical: 25),
                child: TextFormField(
                  onSaved: (value) {
                    setState(() {
                      _newEmail = value;
                    });
                  },
                  decoration: _getDecoration("Email"),
                  style: Styles.loginTextStyle,
                  keyboardType: TextInputType.emailAddress,
                  controller: _newEmailController,
                  focusNode: _newEmailFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _newEmailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_newPasswordFocusNode);
                  },
                  validator: ValidatorHelper.emailValidator,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 75, vertical: 25),
                child: TextFormField(
                  onSaved: (value) {
                    setState(() {
                      _newPassword = value;
                    });
                  },
                  obscureText: true,
                  decoration: _getDecoration("Password"),
                  style: Styles.loginTextStyle,
                  focusNode: _newPasswordFocusNode,
                  textInputAction: TextInputAction.next,
                  controller: _newPasswordController,
                  onFieldSubmitted: (term) {
                    _newPasswordFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(_newPasswordRepeatedFocusNode);
                  },
                  validator: ValidatorHelper.passwordValidator,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 75, vertical: 25),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: _getDecoration("Repeat password"),
                  style: Styles.loginTextStyle,
                  focusNode: _newPasswordRepeatedFocusNode,
                  controller: _newPasswordRepeatedeController,
                  validator: (repeatedPassword) {
                    if (repeatedPassword != _newPasswordController.text)
                      return "Passwords dit not match!";
                    return null;
                  },
                ),
              ),
              Builder(
                  builder: (context) =>GradientButton(
                increaseWidthBy: 70,
                callback: () {
                  if (_formNewUser.currentState.validate()) {
                    _formNewUser.currentState.save();
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _newEmail, password: _newPassword)
                        .then((newUser) {
                          _pop();
                        })
                        .catchError((onError) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Email already used"),
                        duration: Duration(milliseconds: 4000),
                      ));
                    });
                  }
                  //_pop();
                },
                gradient: Styles.buttonGradient,
                child: Text("Create Account", style: Styles.titleTextStyle),
              ),)
            ],
          ),
        ),
      ),
    );
  }

  // Using pushReplacement we remove the LoginPage from the stack
  void _pop() {
    Navigator.pop(context, "true");
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
