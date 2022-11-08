import 'package:chatty/constants.dart';
import 'package:chatty/helper/authenticate.dart';
import 'package:chatty/helper/helperfunction.dart';
import 'package:chatty/routs.dart';
import 'package:chatty/screens/profile/profile_screen.dart';
import 'package:chatty/screens/signInOrsignUp/signIn_screen.dart';
import 'package:chatty/screens/welcome/welcome_screen.dart';
import 'package:chatty/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: userIsLoggedIn ? ProfileScreen() : Authenticate(),
      initialRoute: WelcomeScreen.routeName,
      routes: routes,
    );
  }
}
