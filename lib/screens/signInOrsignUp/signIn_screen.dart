// ignore_for_file: deprecated_member_use

import 'package:chatty/constants.dart';
import 'package:chatty/helper/helperfunction.dart';
import 'package:chatty/screens/profile/profile_screen.dart';
import 'package:chatty/screens/signInOrsignUp/signUp_screen.dart';
import 'package:chatty/services/auth.dart';
import 'package:chatty/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key, required this.toggle}) : super(key: key);

  final Function toggle;

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  HelperFunction helperFunction = new HelperFunction();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController userNameTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot<Map<String, dynamic>>? snapshotUserInfo;

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunction.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunction.saveUserNameSharedPreference(
            snapshotUserInfo?.docs[0].data()["name"]);
        // print("${snapshotUserInfo?.docs[0].data()["name"]}");
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ProfileScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2.8),
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                Text(
                  'Sign In',
                  style: GoogleFonts.aclonica(
                    fontSize: 30,
                    color: kBlackColor,
                  ),
                ),
                Spacer(),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Enter correct email";
                        },
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: kBlackColor,
                          ),
                          hintText: "Enter your email",
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        validator: (val) {
                          return val!.length < 6
                              ? "Enter Password 6+ characters"
                              : null;
                        },
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: kBlackColor),
                          hintText: "Enter your password",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "forgot password?",
                              style: TextStyle(
                                color: kPrimaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    color: kPrimaryColor,
                    onPressed: () => signIn(),
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Text(
                    "Create New Account",
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
