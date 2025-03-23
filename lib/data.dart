import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goatgames25webapp/RouteData.dart';

class UserData {
  String userID = "GG25-150";
  String firstName = 'Hariras';
  String lastName = 'Tongyai';
  bool ibex = true;
  bool isFemale = false;

  Map<String, dynamic> phases = {
    'baseCamp_score': {'completed': false, 'timestamp': null},
    'Crest_Booked': {'completed': false, 'timestamp': null},
    'Crest_score': {'completed': false, 'timestamp': null},
    'CompComplete': {'completed': false, 'timestamp': null},
  };

  Map<String, dynamic> baseCampDetails = {
    'tops': 0,
    'zones': 0,
    'total_score': 0,
    'time_spend': 0,
    'start_time': null,
    'end_time': null,
    'route_data': baseCampRouteData,
  };

  Map<String, dynamic> crestDetails = {
    'tops': 0,
    'zones': 0,
    'total_score': 0,
    'time_spend': 0,
    'start_time': null,
    'end_time': null,
    // 'route_data': crestRouteData,
  };
}

UserData userData = UserData();

class Stages {
  bool baseCamp_score = true;
  bool baseCamp_card = true;
  bool baseCamp_leaderboard = true;
  bool crest_booking = false;
  bool crest_score = false;
  bool crest_card = false;
  bool crest_leaderboard = false;
  bool summit_leaderboard = false;
}

Stages stages = Stages();

Future<Stages> fetchStagesFromFirestore() async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance
          .collection('EventInfo')
          .doc('stagesDoc')
          .get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Stages()
      ..baseCamp_score = data['baseCamp_score'] ?? false
      ..baseCamp_card = data['baseCamp_card'] ?? false
      ..baseCamp_leaderboard = data['baseCamp_leaderboard'] ?? false
      ..crest_booking = data['crest_booking'] ?? false
      ..crest_score = data['crest_score'] ?? false
      ..crest_card = data['crest_card'] ?? false
      ..crest_leaderboard = data['crest_leaderboard'] ?? false
      ..summit_leaderboard = data['summit_leaderboard'] ?? false;
  } else {
    throw Exception("Document does not exist");
  }
}
