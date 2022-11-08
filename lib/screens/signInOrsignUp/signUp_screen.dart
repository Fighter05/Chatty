// ignore_for_file: deprecated_member_use

import 'package:chatty/constants.dart';
import 'package:chatty/helper/helperfunction.dart';
import 'package:chatty/screens/signInOrsignUp/signIn_screen.dart';
import 'package:chatty/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatty/screens/profile/profile_screen.dart';
import 'package:chatty/services/database.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key, required this.toggle}) : super(key: key);
  final Function toggle;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignupScreen> {
  // final List<String> errors = [];
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMetods = new DatabaseMethods();
  HelperFunction helperFunction = new HelperFunction();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        print("${val.uid}");

        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text
        };

        HelperFunction.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunction.saveUserNameSharedPreference(
            userNameTextEditingController.text);

        Constants.myName = userNameTextEditingController.text;

        databaseMetods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kDefaultPadding * 2.8),
                  child: Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        'Create\nNew Account',
                        style: GoogleFonts.aclonica(
                          fontSize: 30,
                          color: kBlackColor,
                        ),
                      ),
                      // Spacer(),
                      SizedBox(
                        height: 54,
                      ),
                      // SignUpForm(),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val!.isEmpty || val.length < 2
                                    ? "Please Provide UserName"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(color: kBlackColor),
                                hintText: "Enter your name",
                                // decoration onto theme.dart
                              ),
                            ),
                            SizedBox(height: 16),
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
                                // decoration onto theme.dart
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
                                // decoration onto theme.dart
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              validator: (val) {
                                return val!.length < 6
                                    ? "Enter Password 6+ characters"
                                    : null;
                              },
                              controller: confirmPasswordTextEditingController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(color: kBlackColor),
                                hintText: "Enter your password",
                                // decoration onto theme.dart
                              ),
                            ),
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
                          onPressed: () => signMeUp(),
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
                          "Sign in",
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
