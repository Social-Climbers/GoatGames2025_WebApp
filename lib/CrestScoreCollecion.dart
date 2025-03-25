import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goatgames25webapp/EventUtil.dart';
import 'package:goatgames25webapp/MainMenu.dart';
import 'package:goatgames25webapp/RouteData.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';

class CrestScoreCard extends StatefulWidget {
  final bool isNew;

  CrestScoreCard({required this.isNew});

  @override
  _CrestScoreCardState createState() => _CrestScoreCardState();
}

class _CrestScoreCardState extends State<CrestScoreCard> {
  bool isFemale = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool disableWeight = false;
  String tier = "Unclassified";
  double totalScore = 0;
  int topN = 0;
  int zoneN = 0;
  double requiredScore = 0;
  int topRoutesRange = 6;
  TextEditingController MinScoreTextController = TextEditingController();
  TextEditingController TopRoutesRangeController = TextEditingController();
  void _updateTop10Routes(List<Map<String, dynamic>> topRoutes) {
    for (var route in crestRouteData) {
      if (topRoutes.contains(route)) {
        route["isTop10"] = true;
      } else {
        route["isTop10"] = false;
      }
      print(
          "Updating route: ${route['Route']} with isTop10: ${route['isTop10']}");
      FirebaseFirestore.instance
          .collection('Climbers')
          .doc(userData.userID)
          .collection('Score')
          .doc('crest')
          .update({
        'crestRouteData': crestRouteData.map((r) {
          if (r['Route'] == route['Route']) {
            r['isTop10'] = route['isTop10'];
          }
          return r;
        }).toList(),
      }).then((onValue) {
        print("Route isTop10 updated in Firebase");
      });
    }
  }

  void _createScore(bool firstTime) {
    if (firstTime) {
      FirebaseFirestore.instance
          .collection('Climbers')
          .doc(userData.userID)
          .collection('Score')
          .doc('crest')
          .set({
        'total': totalScore,
        'start_time': startTime,
        'end_time': endTime,
        'tier': tier,
        'crestRouteData': crestRouteData
      }).then((onValue) {
        print("Score Created");
      });
    }
  }

  void _submitScore() {
    Duration timeSpent = endTime.difference(startTime);
    FirebaseFirestore.instance
        .collection('Climbers')
        .doc(userData.userID)
        .collection('Score')
        .doc('crest')
        .update({
      'top': _topCount(),
      'zone': _zoneCount(),
      'total': totalScore,
      'end_time': endTime,
      'tier': tier,
      'crestRouteData': crestRouteData,
      'time_used':
          '${timeSpent.inHours}h ${timeSpent.inMinutes % 60}m ${timeSpent.inSeconds % 60}s',
    }).then((onValue) {
      print("Score Submitted");
    });
  }

  void _updateRouteInFirebase(Map<String, dynamic> route) {
    FirebaseFirestore.instance
        .collection('Climbers')
        .doc(userData.userID)
        .collection('Score')
        .doc('crest')
        .get()
        .then((doc) {
      if (doc.exists) {
        List<dynamic> routes = doc.data()!['crestRouteData'];
        int index = routes.indexWhere((r) => r['Route'] == route['Route']);
        if (index != -1) {
          routes[index] = route;
          FirebaseFirestore.instance
              .collection('Climbers')
              .doc(userData.userID)
              .collection('Score')
              .doc('crest')
              .update({
            'crestRouteData': routes,
          }).then((onValue) {
            print("Route Updated in Firebase");
          });
        }
      }
    });
  }

  void _updateRouteNoTop10(Map<String, dynamic> route) {
    FirebaseFirestore.instance
        .collection('Climbers')
        .doc(userData.userID)
        .collection('Score')
        .doc('crest')
        .get()
        .then((doc) {
      if (doc.exists) {
        List<dynamic> routes = doc.data()!['crestRouteData'];
        int index = routes.indexWhere((r) => r['Route'] == route['Route']);
        if (index != -1) {
          routes[index] = route;

          routes[index]['isTop10'] = false;
          FirebaseFirestore.instance
              .collection('Climbers')
              .doc(userData.userID)
              .collection('Score')
              .doc('crest')
              .update({
            'crestRouteData': routes,
          }).then((onValue) {
            print("Route Updated in Firebase");
          });
        }
      }
    });
  }

  void _resetIsTop10() {
    for (var route in crestRouteData) {
      route["isTop10"] = false;
      _updateRouteInFirebase(route);
    }
  }

  void _calculateScore() {
    double totalScore = 0;
    bool completedAllSilverhorn = true;
    bool climbedAnyIbex = false;

    // Reset the top 10 flag for all routes
    _resetIsTop10();

    // Filter routes where Top is checked
    var topRoutes = crestRouteData
        .where((route) => route["Top"] == true || route["Zone"] == true)
        .toList();

    // Sort the routes by route number in descending order
    topRoutes.sort((a, b) {
      int aRouteNumber = int.parse(a["Route"]?.split(" ")[1] ?? '0');
      int bRouteNumber = int.parse(b["Route"]?.split(" ")[1] ?? '0');
      return bRouteNumber.compareTo(aRouteNumber);
    });

    // Take the top routes based on the specified range
    topRoutes = topRoutes.take(topRoutesRange).toList();

    // Mark the top routes
    for (var route in topRoutes) {
      route["isTop10"] = true;
      _updateRouteInFirebase(route);
    }

    for (var route in topRoutes) {
      int routeNumber = int.parse(route["Route"]?.split(" ")[1] ?? '0');

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
      var remainingRoutes = crestRouteData
          .where((route) => !route["Top"])
          .toList()
          .take(topRoutesRange - topRoutes.length);

      for (var route in remainingRoutes) {
        if (route["Zone"]) {
          totalScore +=
              route["Zone Points"] * (disableWeight ? 1 : route["Zone Weight"]);
          route["isTop10"] = true; // Mark the zone as part of the top 10
          _updateRouteInFirebase(route); // Update the route in Firebase
        }
      }
    }

    for (var route in crestRouteData) {
      if (!topRoutes.contains(route)) {
        route["isTop10"] = false;
        _updateRouteInFirebase(route); // Update the route in Firebase
      }
    }

    for (var route in topRoutes) {
      print(route['Route']);
    }
    this.totalScore = totalScore;
    tier =
        (totalScore >= requiredScore || climbedAnyIbex) ? "Ibex" : "Silverhorn";
    print(this.totalScore);
    print(tier);

    FirebaseFirestore.instance
        .collection('Climbers')
        .doc(userData.userID)
        .collection('Score')
        .doc('crest')
        .update(
      {
        'total': this.totalScore,
        'tier': tier,
        'top': _topCount(),
        'zone': _zoneCount(),
      },
    );
    _updateData();
    setState(() {});
    _updateTop10Routes(topRoutes);
    // _updateScoreInFirebase(); // Update the score in Firebase
  }

  void _showConfirmationDialog(
    String routeType,
    bool isSelected,
    Function(String) onConfirm,
  ) {
    String action = isSelected ? "unsend" : "confirm";
    TextEditingController witnessController = TextEditingController();
    Color textFieldColor = Colors.white;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$action $routeType route?',
                style: TextStyle(color: AccentColor),
              ),
              SizedBox(height: 8),
              Text(
                'Please enter a witness name',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          content: TextField(
            controller: witnessController,
            decoration: InputDecoration(
              labelText: 'Witness Name',
              labelStyle: TextStyle(color: AccentColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textFieldColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textFieldColor),
              ),
            ),
            style: TextStyle(color: textFieldColor),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AccentColor)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: AccentColor)),
              onPressed: () {
                if (witnessController.text.isEmpty) {
                  setState(() {
                    textFieldColor = AccentColor;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Witness name cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  onConfirm(witnessController.text);
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  int _zoneCount() {
    return crestRouteData.where((route) => route["Zone"] == true).length;
  }

  int _topCount() {
    return crestRouteData.where((route) => route["Top"] == true).length;
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
                  userData.phases['crest_score'] = {
                    'completed': true,
                    'timestamp': DateTime.now(),
                  };
                });
                print(userData.phases);
                _submitScore();
                updateSessionActive(false, "Crest").then((onValue) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                });
                // Navigator.of(context).pop();

                // },
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
    if (widget.isNew) {
      _createScore(true);
    } else {
      FirebaseFirestore.instance
          .collection('Climbers')
          .doc(userData.userID)
          .collection('Score')
          .doc('crest')
          .get()
          .then((doc) {
        if (doc.exists) {
          var data = doc.data()!;
          setState(() {
            startTime = (data['start_time'] as Timestamp).toDate();
            topN = data['top'];
            zoneN = data['zone'];
            totalScore = data['total'] ?? totalScore;
            requiredScore = data['requiredScore'] ?? requiredScore;
            tier = data['tier'] ?? tier;
            endTime = (data['end_time'] as Timestamp).toDate();
          });
          // print(topN);
        }
      }).then((onValue) {
        setState(() {});
      });
    }

    isFemale = userData.isFemale;
    requiredScore = isFemale == false ? 40800 : 34000;
    MinScoreTextController.text = requiredScore.toString();
    TopRoutesRangeController.text = topRoutesRange.toString();
    startTime = DateTime.now();
  }

  void _updateData() {
    FirebaseFirestore.instance
        .collection('Climbers')
        .doc(userData.userID)
        .collection('Score')
        .doc('crest')
        .get()
        .then((doc) {
      if (doc.exists) {
        var data = doc.data()!;
        setState(() {
          topN = data['top'];
          zoneN = data['zone'];
          totalScore = data['total'] ?? totalScore;
        });
      }
    }).then((onValue) {
      setState(() {});
    });
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
        //  leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
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
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                        color: AccentColor,
                        child: Text(
                          "Crest - ${isFemale ? "Female" : "Male"}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
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
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Climbers')
                            .doc(userData.userID)
                            .collection('Score')
                            .doc('crest')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          var infoData = snapshot.data!.data();
                          var basecampData =
                              snapshot.data!.data() as Map<String, dynamic>? ??
                                  {};

                          crestRouteData = (basecampData['crestRouteData']
                                      as List?)
                                  ?.map((item) => item as Map<String, dynamic>)
                                  .toList() ??
                              [];
                          //print(crestRouteData);
                          return Column(
                            children: crestRouteData.map((route) {
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
                                        child: Row(
                                          children: [
                                            Text(
                                              route["Route"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            if (route["verified"] == true)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _showConfirmationDialog(
                                            "zone",
                                            route["Zone"],
                                            (witness) {
                                              setState(() {
                                                route["Zone"] = !route["Zone"];
                                                if (!route["Zone"])
                                                  route["Top"] = false;
                                                route["verified"] = true;
                                                route["verifiedBy"] = witness;
                                                _calculateScore();

                                                _updateRouteInFirebase(route);
                                                // Update the route in Firebase
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
                                              color: route["Zone"]
                                                  ? AccentColor
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: AccentColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: route["Zone"]
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
                                            (witness) {
                                              setState(() {
                                                route["Top"] = !route["Top"];
                                                if (route["Top"])
                                                  route["Zone"] = true;
                                                route["verified"] = true;
                                                route["verifiedBy"] = witness;
                                                _calculateScore();
                                                _updateRouteInFirebase(route);
                                                // Update the route in Firebase
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
                                              color: route["Top"]
                                                  ? AccentColor
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: AccentColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: route["Top"]
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
                                '${zoneN}',
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
                                '${topN}',
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
