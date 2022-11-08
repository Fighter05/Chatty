import 'package:chatty/screens/signInOrsignUp/signIn_screen.dart';
import 'package:chatty/screens/signInOrsignUp/signUp_screen.dart';
import 'package:flutter/material.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key }) : super(key: key);
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SigninScreen(toggle: toggleView);
      }
      else{
        return SignupScreen(toggle: toggleView);
      }
  }
}