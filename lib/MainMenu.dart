import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goatgames25webapp/BaseCampCardView.dart';
import 'package:goatgames25webapp/BaseCampScoreCollecion.dart';
import 'package:goatgames25webapp/BasecampLeaderboard.dart';
import 'package:goatgames25webapp/BookSlot.dart';
import 'package:goatgames25webapp/ButtonBox.dart';
import 'package:goatgames25webapp/CrestCardView.dart';
import 'package:goatgames25webapp/CrestLeaderboard.dart';
import 'package:goatgames25webapp/CrestScoreCollecion.dart';
import 'package:goatgames25webapp/EventUtil.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';
import 'package:goatgames25webapp/loading.dart';
import 'package:goatgames25webapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool baseCampActive = false;
  bool crestActive = false;
  @override
  void initState() {
    super.initState();
    getUserIDLocal().then((_) {
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        fetchUserDataFromFirestore().then((onValue) {
          print("User Data Fetched:");
          print(userData.userID);
          print(userData.firstName);
          print(userData.tier);
          _loading = false;
          setState(() {});
        });
      });
    });

    checkForActiveBaseCampSession();
    checkForActiveCrestSession();
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      setState(() {});
    });
  }

  Future<void> getUserIDLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userIDLocal');
    if (userID != null) {
      userData.userID = userID;
      print("Id Set Complete");
    } else {
      // Handle the case where userIDLocal does not exist
      print("userIDLocal does not exist in SharedPreferences");
    }
  }

  void checkForActiveBaseCampSession() async {
    print("Checking for Active Session");
    if (await getSessionActive("Basecamp") == true) {
      print("BaseCamp Session Found");
      baseCampActive = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BaseCampScoreCard(isNew: false)),
      ).then((_) {
        setState(() {});
      });
      await Future.delayed(Duration(milliseconds: 200));
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }
  }

  void checkForActiveCrestSession() async {
    print("Checking for Active Session");
    if (await getSessionActive("Crest") == true) {
      print("Crest Session Found");
      baseCampActive = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CrestScoreCard(isNew: false)),
      ).then((_) {
        setState(() {});
      });
      await Future.delayed(Duration(milliseconds: 200));
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }
  }

  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: _loading
          ? LoadingScreen()
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                // color: const Color.fromARGB(255, 28, 28, 28),
                // padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // color: Colors.black,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/sgicon.png', height: 40),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.refresh, color: Colors.white),
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, color: Colors.white),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          // Text(
                          //   'Goat Games 2025',
                          //   style: TextStyle(color: AccentColor, fontSize: 20),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        // color: Colors.black,
                        boxShadow: [
                          // BoxShadow(
                          //   color: AccentColor,
                          //   spreadRadius: 1,
                          //   blurRadius: 7,
                          //   offset: Offset(0, 3),
                          // ),
                        ],
                        // borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: AccentColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.08,
                                ),
                              ),
                              Text(
                                '${userData.firstName}',
                                style: TextStyle(
                                  color: AccentColor,
                                  fontSize: size.width * 0.06,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'ID: ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: userData.userID,
                                      style: TextStyle(
                                        color: AccentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          stages.baseCamp_leaderboard
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          color: AccentColor,
                                          fontSize: size.width * 0.04,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: size.width * 0.3,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          // BoxShadow(
                                          //   color: AccentColor,
                                          //   spreadRadius: 1,
                                          //   blurRadius: 7,
                                          //   offset: Offset(0, 3),
                                          // ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AccentColor),
                                      ),
                                      child: Text(
                                        userData.tier,
                                        style: TextStyle(
                                          color: AccentColor,
                                          fontSize: size.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SponsorBox(),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          stages.baseCamp_score
                              // ? userData.phases['baseCamp_score']['completed'] ==
                              //         !true
                              ? MenuButton(
                                  context,
                                  "Basecamp",
                                  "Score Collection",
                                  "assets/bc_logo.jpg",
                                  BaseCampScoreCard(
                                    isNew: true,
                                  ),
                                  true,
                                  "Start")
                              : SizedBox(),

                          // userData.phases['baseCamp_score']['completed'] == true
                          stages.baseCamp_card
                              ? MenuButton(
                                  context,
                                  "Basecamp",
                                  "Scorecard",
                                  "assets/bc_logo.jpg",
                                  BaseCampCardView(),
                                  false,
                                  "View")
                              : SizedBox(),

                          stages.baseCamp_leaderboard
                              ? MenuButton(
                                  context,
                                  "Basecamp",
                                  "Leadboard",
                                  "assets/bc_logo.jpg",
                                  BasecampLeaderboard(),
                                  false,
                                  "View")
                              : SizedBox(),
                          stages.crest_booking
                              ? MenuButton(
                                  context,
                                  "Crest",
                                  "Timeslots",
                                  "assets/bc_logo.jpg",
                                  CrestSlotBookingPage(),
                                  false,
                                  "Book")
                              : SizedBox(),
                          stages.crest_score
                              ? userData.phases['Crest_score']['completed'] ==
                                      !true
                                  ? MenuButton(
                                      context,
                                      "Crest",
                                      "Score Collection",
                                      "assets/crest_logo.jpg",
                                      CrestScoreCard(isNew: true),
                                      true,
                                      "Start")
                                  : SizedBox()
                              : SizedBox(),
                          stages.crest_card
                              ? MenuButton(
                                  context,
                                  "Crest",
                                  "Score Card",
                                  "assets/crest_logo.jpg",
                                  CrestCardView(),
                                  false,
                                  "View")
                              : SizedBox(),
                          stages.crest_leaderboard
                              ? MenuButton(
                                  context,
                                  "Crest",
                                  "Leadboard",
                                  "assets/crest_logo.jpg",
                                  CrestLeaderboard(),
                                  false,
                                  "View")
                              : SizedBox(),
                          stages.crest_leaderboard
                              ? MenuButton(
                                  context,
                                  "Summit",
                                  "Leadboard",
                                  "assets/summit_logo.jpg",
                                  CrestLeaderboard(),
                                  false,
                                  "View")
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget MenuButton(
    BuildContext context,
    String title,
    String feature,
    String image,
    Widget location,
    bool isActive,
    String action,
  ) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: size.height * 0.12,
        width: size.width * 0.95,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? AccentColor : Colors.black.withOpacity(1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    image,
                    height: size.height * 0.1,
                    width: size.height * 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.03,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: isActive ? Colors.black : AccentColor,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                if (isActive) {
                  bool? confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          "Confirmation",
                          style: TextStyle(color: AccentColor),
                        ),
                        content: Text(
                          "Are you sure you want to start the collection?",
                          style: TextStyle(color: AccentColor),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("No",
                                style: TextStyle(color: AccentColor)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text("Yes",
                                style: TextStyle(color: AccentColor)),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    updateSessionActive(true, title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => location),
                    ).then((onValue) {
                      setState(() {});
                    });
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => location),
                  ).then((onValue) {
                    setState(() {});
                  });
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: size.width * 0.05,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: size.width * 0.05,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      action,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.03,
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
}
