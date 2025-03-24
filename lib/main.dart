import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goatgames25webapp/BaseCampCardView.dart';
import 'package:goatgames25webapp/BaseCampScoreCollecion.dart';
import 'package:goatgames25webapp/BasecampLeaderboard.dart';
import 'package:goatgames25webapp/MainMenu.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';
import 'package:goatgames25webapp/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //fetchPhasesFromFirestore();
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
          MainPage(userId: 'GG25-150'),
    );
  }
}

class GoatGamesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Goat Games 2025', home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/bg.jpg'),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Container(
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(border: Border.all(color: AccentColor)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/sgicon.png', height: 100),
              SizedBox(height: 20),
              TextField(
                controller: idController,
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
              ),
              SizedBox(height: 20),
              TextField(
                controller: TextEditingController(),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AccentColor),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AccentColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AccentColor),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility, color: AccentColor),
                    onPressed: () {
                      // Toggle obscureText
                    },
                  ),
                ),
                style: TextStyle(color: AccentColor),
              ),
              SizedBox(height: 10),
              Text(
                'Password format is Your ID + Birthday (IDMMDDYYYY) \ni.e (ID: 112 Day: 01 Month: 02 Year: 1992) 11201021992',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  backgroundColor: AccentColor, // Background color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(userId: idController.text),
                    ),
                  );
                },
                child: Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BaseCampScorePage extends StatelessWidget {
  final String userId;

  BaseCampScorePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Base Camp Score Submission')),
      body: Center(child: Text('Submit scores here for ID: $userId')),
    );
  }
}

class CrestScoreCollectionPage extends StatelessWidget {
  final String userId;
  final String tier;

  CrestScoreCollectionPage({required this.userId, required this.tier});

  final String startTime = '10:00 AM';
  final String endTime = '1:00 PM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crest Score Collection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userData.firstName}'),
            Text('ID: $userId'),
            Text('Tier: $tier'),
            Text('Start Time: $startTime'),
            Text('End Time: $endTime'),
            SizedBox(height: 20),
            Text('Score input or collection functionality here'),
          ],
        ),
      ),
    );
  }
}
