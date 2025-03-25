import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goatgames25webapp/Theme.dart';

class CrestLeaderboard extends StatelessWidget {
  Future<Map<String, dynamic>> fetchClimberScore(String userID) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Climbers')
          .doc(userID)
          .collection('Score')
          .doc('crest')
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception('Error fetching climber score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Crest Leaderboard',
                      style: TextStyle(color: AccentColor)),
                  Image.asset('assets/bc_logo.jpg', height: size.height * 0.05),
                ],
              ),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          body: Column(
            children: [
              Container(
                  width: size.width, color: Colors.black, child: SponsorBox()),
              TabBar(
                indicatorColor: AccentColor,
                labelColor: AccentColor,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(text: 'Male'),
                  Tab(text: 'Female'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildLeaderboard(context, false),
                    _buildLeaderboard(context, true),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildLeaderboard(BuildContext context, bool isFemale) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Climbers').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<DocumentSnapshot> filteredUsers = snapshot.data!.docs
              .where((doc) => doc['isFemale'] == isFemale)
              .toList();
          List<DocumentSnapshot> silverhornUsers = filteredUsers
              .where((doc) => doc['tier'] == 'Silverhorn')
              .toList()
            ..sort((a, b) => b['totalscore'].compareTo(a['totalscore']));
          List<DocumentSnapshot> ibexUsers = filteredUsers
              .where((doc) => doc['tier'] == 'Ibex')
              .toList()
            ..sort((a, b) => b['totalscore'].compareTo(a['totalscore']));

          return ListView(
            children: [
              _buildCategoryLabel('Silverhorn'),
              ...silverhornUsers.map(
                (doc) => Container(
                  child: Row(
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchClimberScore(doc['userID']),
                        builder: (context, scoreSnapshot) {
                          if (scoreSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (scoreSnapshot.hasError) {
                            return Text('Error: ${scoreSnapshot.error}');
                          }
                          if (!scoreSnapshot.hasData) {
                            return Text('No score available');
                          }

                          var scoreData = scoreSnapshot.data!;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            height: size.height * 0.125,
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['userID'] + ' ',
                                              style:
                                                  TextStyle(color: AccentColor),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          doc['first_name'] +
                                              ' ' +
                                              doc['last_name'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Time: ',
                                              style:
                                                  TextStyle(color: AccentColor),
                                            ),
                                            Text(
                                              '${scoreData['time_used']}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ' Top',
                                              style:
                                                  TextStyle(color: AccentColor),
                                            ),
                                            Text(
                                              '${scoreData['top']}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(' Zone',
                                                style: TextStyle(
                                                  color: AccentColor,
                                                )),
                                            Text(
                                              '${scoreData['zone']}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildCategoryLabel('Ibex'),
              ...ibexUsers.map(
                (doc) => Container(
                  child: Row(
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchClimberScore(doc['userID']),
                        builder: (context, scoreSnapshot) {
                          if (scoreSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (scoreSnapshot.hasError) {
                            return Text('Error: ${scoreSnapshot.error}');
                          }
                          if (!scoreSnapshot.hasData) {
                            return Text('No score available');
                          }

                          var scoreData = scoreSnapshot.data!;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            height: size.height * 0.125,
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['userID'] + ' ',
                                              style:
                                                  TextStyle(color: AccentColor),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          doc['first_name'] +
                                              ' ' +
                                              doc['last_name'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Time: ',
                                              style:
                                                  TextStyle(color: AccentColor),
                                            ),
                                            Text(
                                              '${scoreData['time_used']}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ' Top',
                                              style:
                                                  TextStyle(color: AccentColor),
                                            ),
                                            Text(
                                              '${scoreData['top']}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(' Zone',
                                                style: TextStyle(
                                                  color: AccentColor,
                                                )),
                                            Text(
                                              '${scoreData['zone']}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryLabel(String category) {
    return Container(
      color: AccentColor,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        category,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
