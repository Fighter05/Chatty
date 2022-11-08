import 'package:chatty/constants.dart';
import 'package:chatty/helper/authenticate.dart';
import 'package:chatty/helper/helperfunction.dart';
import 'package:chatty/screens/messages/message_screen.dart';
import 'package:chatty/services/auth.dart';
import 'package:chatty/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  HelperFunction helperFunction = new HelperFunction();

  AuthMethods authMethods = new AuthMethods();

  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  Stream<QuerySnapshot>? chatRoomStream;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot?.docs[index].data()["name"],
                userEmail: searchSnapshot?.docs[index].data()["email"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    databaseMethods
        .getUserByEmail(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatroomAndStartConversation({required String userName}) {
    print("${Constants.myName}");
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "user": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatroom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MessageScreen(chatRoomId)));
    } else {
      print("you cannot send message to yourself");
    }
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          createChatroomAndStartConversation(userName: userName);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 1.25,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, top: 5),
                      child: Text(
                        "${userName.substring(0, 1).toUpperCase()}",
                        style: GoogleFonts.balooTammudu2(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                    backgroundColor: kPrimaryColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      userName,
                      style: GoogleFonts.balooTammudu2(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunction.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarProfile(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_profile_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                initiateSearch();
              },
              child: Container(
                color: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        // style: TextStyle(fontSize: 12.5, height: 1.5, color: kWhiteColor),
                        style: TextStyle(color: kWhiteColor),
                        decoration: InputDecoration(
                          // labelText: "Search...",
                          // labelStyle: TextStyle(color: kWhiteColor),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white54),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 24),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: kWhiteColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(color: kWhiteColor),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 2.0, 8.0, 2.0),
                            child: IconButton(
                              icon: Icon(Icons.search),
                              color: kWhiteColor,
                              onPressed: () {
                                initiateSearch();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBarProfile() {
    final String userName = Constants.myName;
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 88.0,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36.0,
              backgroundImage: AssetImage("assets/images/Ellipse 5.png"),
            ),
          ],
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          userName,
          style: GoogleFonts.balooTammudu2(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: kWhiteColor,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () {
            authMethods.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate()));
          },
          child: Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
            ),
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: kPrimaryColor,
    );
  }
}

getChatRoomId(String a, String b) {
  if ((a.compareTo(b) > 0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
