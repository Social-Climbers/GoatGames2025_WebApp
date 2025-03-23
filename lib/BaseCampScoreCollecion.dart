import 'package:flutter/material.dart';
import 'package:goatgames25webapp/RouteData.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';

class BaseCampScoreCard extends StatefulWidget {
  @override
  _BaseCampScoreCardState createState() => _BaseCampScoreCardState();
}

class _BaseCampScoreCardState extends State<BaseCampScoreCard> {
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

  void _calculateScore() {
    double totalScore = 0;
    bool completedAllSilverhorn = true;
    bool climbedAnyIbex = false;

    // Reset the top 10 flag for all routes
    for (var route in baseCampRouteData) {
      route["isTop10"] = false;
    }

    // Filter routes where Top is checked
    var topRoutes =
        baseCampRouteData
            .where((route) => route["Top"] == true || route["Zone"] == true)
            .toList();

    // Sort the routes by route number in descending order
    topRoutes.sort((a, b) {
      int aRouteNumber = int.parse(a["Route"].split(" ")[1]);
      int bRouteNumber = int.parse(b["Route"].split(" ")[1]);
      return bRouteNumber.compareTo(aRouteNumber);
    });

    // Take the top routes based on the specified range
    topRoutes = topRoutes.take(topRoutesRange).toList();

    // Mark the top routes
    for (var route in topRoutes) {
      route["isTop10"] = true;
    }

    for (var route in topRoutes) {
      int routeNumber = int.parse(route["Route"].split(" ")[1]);

      if (routeNumber >= 13 && route["Top"]) {
        climbedAnyIbex = true;
      }

      bool isSilverhorn =
          (isFemale && routeNumber <= 12) || (!isFemale && routeNumber <= 9);

      if (route["Top"]) {
        totalScore +=
            route["Top Points"] * (disableWeight ? 1 : route["Top Weight"]);
      } else if (isSilverhorn) {
        completedAllSilverhorn = false;
      }

      if (route["Zone"]) {
        totalScore +=
            route["Zone Points"] * (disableWeight ? 1 : route["Zone Weight"]);
      }

      if ((isFemale && routeNumber >= 10 && route["Top"]) ||
          (!isFemale && routeNumber >= 13 && route["Top"])) {
        climbedAnyIbex = true;
      }
    }

    // If there are less than 10 top routes, add the zone points of the remaining routes
    if (topRoutes.length < topRoutesRange) {
      var remainingRoutes = baseCampRouteData
          .where((route) => !route["Top"])
          .toList()
          .take(topRoutesRange - topRoutes.length);

      for (var route in remainingRoutes) {
        if (route["Zone"]) {
          totalScore +=
              route["Zone Points"] * (disableWeight ? 1 : route["Zone Weight"]);
          route["isTop10"] = true; // Mark the zone as part of the top 10
        }
      }
    }

    this.totalScore = totalScore;
    tier =
        (totalScore >= requiredScore || climbedAnyIbex) ? "Ibex" : "Silverhorn";
    print(this.totalScore);
    print(tier);
    setState(() {});
  }

  void _showConfirmationDialog(
    String routeType,
    bool isSelected,
    Function onConfirm,
  ) {
    String action = isSelected ? "unsend" : "confirm";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            '$action $routeType route?',
            style: TextStyle(color: AccentColor),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AccentColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: AccentColor)),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int _zoneCount() {
    return baseCampRouteData.where((route) => route["Zone"] == true).length;
  }

  int _topCount() {
    return baseCampRouteData.where((route) => route["Top"] == true).length;
  }

  void _showSubmitDialog() {
    endTime = DateTime.now();
    Duration timeSpent = endTime.difference(startTime);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text('Submit Score?', style: TextStyle(color: AccentColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Zones: ', style: TextStyle(color: AccentColor)),
                  Text(
                    '${_zoneCount()}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Tops: ', style: TextStyle(color: AccentColor)),
                  Text('${_topCount()}', style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Text('Start Time: ', style: TextStyle(color: AccentColor)),
                  Text(
                    '${startTime.hour}:${startTime.minute}:${startTime.second}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('End Time: ', style: TextStyle(color: AccentColor)),
                  Text(
                    '${endTime.hour}:${endTime.minute}:${endTime.second}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Time Spent: ', style: TextStyle(color: AccentColor)),
                  Text(
                    '${timeSpent.inHours}h ${timeSpent.inMinutes % 60}m ${timeSpent.inSeconds % 60}s',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AccentColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit', style: TextStyle(color: AccentColor)),
              onPressed: () {
                setState(() {
                  userData.baseCampDetails['start_time'] = startTime;
                  userData.baseCampDetails['end_time'] = endTime;
                  userData.phases['baseCamp_score'] = {
                    'completed': true,
                    'timestamp': DateTime.now(),
                  };
                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    isFemale = userData.isFemale;
    requiredScore = isFemale == false ? 40800 : 34000;
    MinScoreTextController.text = requiredScore.toString();
    TopRoutesRangeController.text = topRoutesRange.toString();
    startTime = DateTime.now();
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                          '${startTime.day}/${startTime.month}/${startTime.year} ${startTime.hour}:${startTime.minute}:${startTime.second}',
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
                        // if (route["Zone"]) {
                        //   rowColor = Colors.grey[200]!;
                        // }
                        // if (route["Top"]) {
                        //   rowColor = Colors.grey[300]!;
                        // }
                        // if (route["isTop10"]) {
                        //   rowColor = Colors.blue[100]!;
                        // }
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
                                child: GestureDetector(
                                  onTap: () {
                                    _showConfirmationDialog(
                                      "zone",
                                      route["Zone"],
                                      () {
                                        setState(() {
                                          route["Zone"] = !route["Zone"];
                                          if (!route["Zone"]) {
                                            route["Top"] = false;
                                          }
                                          _calculateScore();
                                        });
                                      },
                                    );
                                  },
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
                                              : Text(
                                                "Zone",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showConfirmationDialog(
                                      "top",
                                      route["Top"],
                                      () {
                                        setState(() {
                                          route["Top"] = !route["Top"];
                                          if (route["Top"]) {
                                            route["Zone"] = true;
                                          }
                                          _calculateScore();
                                        });
                                      },
                                    );
                                  },
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
                                              : Text(
                                                "Top",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
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
          Positioned(
            bottom: 0,

            child: Center(
              child: Container(
                width: size.width,
                color: Colors.black,
                child: Column(
                  children: [
                    Divider(thickness: 2, color: Colors.white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Zones: ',
                                style: TextStyle(
                                  color: AccentColor,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${_zoneCount()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tops: ',
                                style: TextStyle(
                                  color: AccentColor,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${_topCount()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(4),
                      width: double.infinity,
                      height: size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: _showSubmitDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AccentColor,
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
