import 'package:chatty/constants.dart';
import 'package:chatty/helper/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = "/welcome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Authenticate()),
            ),
            child: Text(
              'CHATTY',
              style: GoogleFonts.aclonica(
                fontSize: 40,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
