import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goatgames25webapp/RouteData.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';
import 'package:intl/intl.dart';

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
    // Future.delayed(Duration(milliseconds: 1500), () {
    //   setState(() {});
    // });
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
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Climbers')
                  .doc(userData.userID)
                  .collection('Score')
                  .doc('basecamp')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No base camp details found'));
                }
                var baseCampDetails =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: size.width * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData.firstName + " " + userData.lastName,
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
                            Row(
                              children: [
                                Text(
                                  'Zone: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  baseCampDetails['zone'].toString(),
                                  style: TextStyle(
                                    color: AccentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Top: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  baseCampDetails['top'].toString(),
                                  style: TextStyle(
                                    color: AccentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                          DateFormat('dd/MM/yyyy HH:mm:ss')
                              .format(
                                  (baseCampDetails['start_time'] as Timestamp)
                                      .toDate())
                              .toString(),
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
                          DateFormat('dd/MM/yyyy HH:mm:ss')
                              .format((baseCampDetails['end_time'] as Timestamp)
                                  .toDate())
                              .toString(),
                          style: TextStyle(
                            color: AccentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              color: AccentColor,
              child: Text(
                "Basecamp - ${isFemale ? "Female" : "Male"}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Climbers')
                        .doc(userData.userID)
                        .collection('Score')
                        .doc('basecamp')
                        .get(),
                    builder: (context, snapshot) {
                      // var data = snapshot.data!.data() as Map<String, dynamic>;
                      // print(data['basecampRouteData'][1]);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No data found'));
                      }
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      //  print(data['basecampRouteData']);
                      var baseCampRouteDataOnline = data['basecampRouteData'];
                      if (baseCampRouteData == null) {
                        return Center(child: Text('No route data found'));
                      }
                      return Column(
                        children: (baseCampRouteDataOnline as List<dynamic>)
                            .map<Widget>((route) {
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
                                      route["Route"] ?? 'Unknown Route',
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
                                        color: route["Zone"] == true
                                            ? AccentColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: AccentColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: route["Zone"] == true
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
                                        color: route["Top"] == true
                                            ? AccentColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: AccentColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: route["Top"] == true
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
                      );
                    },
                  ),
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
