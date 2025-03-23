import 'package:flutter/material.dart';
import 'package:goatgames25webapp/BaseCampCardView.dart';
import 'package:goatgames25webapp/BaseCampScoreCollecion.dart';
import 'package:goatgames25webapp/BasecampLeaderboard.dart';
import 'package:goatgames25webapp/ButtonBox.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';
import 'package:goatgames25webapp/main.dart';

class MainPage extends StatelessWidget {
  final String userId;

  MainPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
                  children: [
                    Image.asset('assets/sgicon.png', height: 40),
                    SizedBox(width: 5),
                    // Text(
                    //   'Goat Games 2025',
                    //   style: TextStyle(color: AccentColor, fontSize: 20),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(16.0),
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
                    Stages().baseCamp_leaderboard
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
                                userData.ibex ? "Ibex" : "Silverhorn",
                                style: TextStyle(
                                  color: AccentColor,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                            ),
                          ],
                        )
                        : SizedBox(),
                  ],
                ),
              ),
              SponsorBox(),

              Expanded(
                child: ListView(
                  children: [
                    Stages().baseCamp_score
                        ? userData.phases['baseCamp_score']['completed'] ==
                                !true
                            ? MenuButton(
                              context,
                              "Basecamp",
                              "Score Collection",
                              "assets/bc_logo.jpg",
                              BaseCampScoreCard(),
                              true,
                            )
                            : SizedBox()
                        : SizedBox(),
                    Stages().baseCamp_card
                        ? MenuButton(
                          context,
                          "Basecamp",
                          "Scorecard",
                          "assets/bc_logo.jpg",
                          BaseCampCardView(),
                          false,
                        )
                        : SizedBox(),
                    Stages().baseCamp_leaderboard
                        ? MenuButton(
                          context,
                          "Basecamp",
                          "Leadboard",
                          "assets/bc_logo.jpg",
                          BasecampLeaderboard(),
                          false,
                        )
                        : SizedBox(),
                    Stages().crest_booking
                        ? MenuButton(
                          context,
                          "Crest",
                          "Timeslots",
                          "assets/bc_logo.jpg",
                          BaseCampScorePage(userId: userId),
                          false,
                        )
                        : SizedBox(),
                    Stages().crest_score
                        ? userData.phases['Crest_score']['completed'] == !true
                            ? MenuButton(
                              context,
                              "Crest",
                              "Crest Collection",
                              "assets/crest_logo.jpg",
                              BaseCampScorePage(userId: userId),
                              false,
                            )
                            : SizedBox()
                        : SizedBox(),
                    Stages().crest_leaderboard
                        ? MenuButton(
                          context,
                          "Crest",
                          "Leaderboard",
                          "assets/crest_logo.jpg",
                          BaseCampScorePage(userId: userId),
                          false,
                        )
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => location),
                );
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
                      'Start',
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
