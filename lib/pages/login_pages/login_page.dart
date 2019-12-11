import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiking_app/pages/login_pages/reset_password_page.dart';
import 'package:hiking_app/pages/login_pages/sign_up_page.dart';
import 'package:hiking_app/utils/validator_helper.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Styles.backGroundColor),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome to HikingApp!',
                  style: Styles.titleList,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 70, right: 70),
                  child: TextFormField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _getDecoration("Email"),
                    style: Styles.loginTextStyle,
                    onFieldSubmitted: (term) {
                      _emailFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    validator: ValidatorHelper.emailValidator,
                    onSaved: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 35, left: 70, right: 70, bottom: 55),
                  child: TextFormField(
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: _getDecoration("Password"),
                    style: Styles.loginTextStyle,
                    validator: ValidatorHelper.passwordValidator,
                    onSaved: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                ),
                Builder(
                  builder: (context) => GradientButton(
                        increaseWidthBy: 175,
                        callback: () {
                          _validateForm(context);
                        },
                        gradient: Styles.buttonGradient,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Log-In", style: Styles.titleTextStyle),
                            Icon(FontAwesomeIcons.signInAlt),
                          ],
                        ),
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GradientButton(
                      increaseWidthBy: 40,
                      callback: () {
                        _pushSignUpPage();
                      },
                      gradient: Styles.tileGradient,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Sign-Up", style: Styles.titleTextStyle),
                          Icon(
                            FontAwesomeIcons.userPlus,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GradientButton(
                      increaseWidthBy: 40,
                      callback: _pushSignUpGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Google", style: Styles.googleButtonTextStyle),
                          Icon(
                            FontAwesomeIcons.googlePlusG,
                            size: 15,
                          ),
                        ],
                      ),
                      gradient: Styles.googleSignButtonGradient,
                    ),
                  ],
                ),
                FlatButton(
                  child: Text("Forgot password?", style: Styles.loginTextStyle,),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
         FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password).then((FirebaseUser firebaseUser){
          }).catchError((onError){
            Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("User not found"),
          action: SnackBarAction(
            label: 'Create user',
            onPressed: () => _pushSignUpPage(),
          ),
          duration: Duration(milliseconds: 4000),
        ));
          });
    }
  }

  void _pushSignUpPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
   
  }

  void _pushSignUpGoogle() async {
    await _handleSignIn();
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

  

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }
}
