import 'package:flutter/material.dart';
import 'package:goatgames25webapp/RouteData.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';

class BaseCampCardView extends StatefulWidget {
  @override
  _BaseCampCardViewState createState() => _BaseCampCardViewState();
}

class _BaseCampCardViewState extends State<BaseCampCardView> {
  bool isFemale = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool disableWeight = false;
  String tier = "Unclassified";
  double totalScore = 0;
  double requiredScore = 0;
  int topRoutesRange = 10;
  TextEditingController MinScoreTextController = TextEditingController();
  TextEditingController TopRoutesRangeController = TextEditingController();

  void Update() {}

  @override
  void initState() {
    super.initState();
    isFemale = userData.isFemale;
    requiredScore = isFemale == false ? 40800 : 34000;
    MinScoreTextController.text = requiredScore.toString();
    TopRoutesRangeController.text = topRoutesRange.toString();
    startTime = DateTime.now();
    endTime = DateTime.now(); // Set end time for display
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Scorecard', style: TextStyle(color: AccentColor)),
            Image.asset('assets/bc_logo.jpg', height: size.height * 0.05),
          ],
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: size.width * 0.1,
                    ),
                    SizedBox(width: size.width * 0.02),
                    Column(
                      children: [
                        Text(
                          '${userData.firstName}',
                          style: TextStyle(
                            color: AccentColor,
                            fontSize: size.width * 0.04,
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
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Start Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData.baseCampDetails['start_time'],
                      style: TextStyle(
                        color: AccentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'End Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData.baseCampDetails['end_time'],
                      style: TextStyle(
                        color: AccentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SponsorBox(),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.grey[300],
                          child: Text(
                            "Route",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.grey[300],
                          child: Text(
                            "Zone",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.grey[300],
                          child: Text(
                            "Top",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...baseCampRouteData.map((route) {
                    Color rowColor = Colors.transparent;
                    return Container(
                      height: size.height * 0.08,
                      color: rowColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                route["Route"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: size.width * 0.3,
                                height: size.height * 0.06,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      route["Zone"]
                                          ? route["isTop10"]
                                              ? AccentColor
                                              : Colors.grey
                                          : Colors.transparent,
                                  border: Border.all(
                                    color: AccentColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child:
                                    route["Zone"]
                                        ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                        : Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.06,
                                width: size.width * 0.3,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      route["Top"]
                                          ? route["isTop10"]
                                              ? AccentColor
                                              : Colors.grey
                                          : Colors.transparent,
                                  border: Border.all(
                                    color: AccentColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child:
                                    route["Top"]
                                        ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                        : Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: size.height * 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
