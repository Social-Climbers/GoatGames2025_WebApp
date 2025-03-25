import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goatgames25webapp/BaseCampCardView.dart';
import 'package:goatgames25webapp/BaseCampScoreCollecion.dart';
import 'package:goatgames25webapp/BasecampLeaderboard.dart';
import 'package:goatgames25webapp/EventUtil.dart';
import 'package:goatgames25webapp/MainMenu.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/appinfo.dart';
import 'package:goatgames25webapp/data.dart';
import 'package:goatgames25webapp/firebase_options.dart';
import 'package:goatgames25webapp/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

String appVersion = 'Fetching Version';
String? userIDLocal;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //getAppVersion();
  //fetchPhasesFromFirestore();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // userIDLocal = prefs.getString('userIDLocal');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goat Games 2025',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey.shade900,
        textTheme: GoogleFonts.silkscreenTextTheme(Theme.of(context).textTheme),
        // textTheme: TextTheme(
        //   bodyText1: TextStyle(color: AccentColor,),
        //   bodyText2: TextStyle(color: AccentColor,),
        // ),
      ),
      home:
          // BasecampLeaderboard()
          //BaseCampCardView(),
          //BaseCampScoreCard(),
          AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print("User Not logged in");

          return LoginPage();
        }

        print("User Logged in");

        return MainPage();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  bool _loading = true;
  @override
  void initState() {
    printAppVersion().then((onValue) {});
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _loading
          ? LoadingScreen()
          : Container(
              height: size.height,
              width: size.width,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(18.0),
                decoration:
                    BoxDecoration(border: Border.all(color: AccentColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Image.asset('assets/sgicon.png', height: 100),
                    SizedBox(height: 20),
                    TextField(
                      maxLength: 3,
                      controller: idController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "000",
                        prefixText: "GG25-",
                        labelText: 'Enter your User ID',
                        labelStyle: TextStyle(color: AccentColor),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AccentColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AccentColor),
                        ),
                      ),
                      style: TextStyle(color: AccentColor),
                      cursorColor: AccentColor,
                    ),
                    SizedBox(height: 20),
                    // TextField(
                    //   controller: TextEditingController(),
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     labelText: 'Password',
                    //     labelStyle: TextStyle(color: AccentColor),
                    //     filled: true,
                    //     fillColor: Colors.black.withOpacity(0.5),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: AccentColor),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: AccentColor),
                    //     ),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(Icons.visibility, color: AccentColor),
                    //       onPressed: () {
                    //         // Toggle obscureText
                    //       },
                    //     ),
                    //   ),
                    //   style: TextStyle(color: AccentColor),
                    // ),
                    // SizedBox(height: 10),
                    // Text(
                    //   'Password format is Your ID + Birthday (IDMMDDYYYY) \ni.e (ID: 112 Day: 01 Month: 02 Year: 1992) 11201021992',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24),
                        backgroundColor: AccentColor, // Background color
                      ),
                      onPressed: () {
                        if (idController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'User ID cannot be empty',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        } else {
                          _loading = true;
                          setState(() {});
                          String id = "GG25-" + idController.text;

                          FirebaseFirestore.instance
                              .collection('Climbers')
                              .doc(id)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setString('userIDLocal', id);
                              });
                              FirebaseAuth.instance
                                  .signInAnonymously()
                                  .then((onValue) {
                                Future.delayed(Duration(milliseconds: 2000))
                                    .then((_) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainPage(),
                                    ),
                                  );
                                });
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'User ID does not exist',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: Icon(Icons.arrow_forward, color: Colors.black),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.warning, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Confidential Build - DO NOT LEAK',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8),
                              ),
                            ),
                            Text(
                              'Property of Stongoat Climb & Social Climbers',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8),
                            ),
                            Text(
                              'Development Version: ${appVersion}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
