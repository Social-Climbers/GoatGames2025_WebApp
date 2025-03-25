import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goatgames25webapp/RouteData.dart';

class UserData {
  String userID = "GG25-150";
  String firstName = 'NA';
  String lastName = 'NA';
  bool ibex = true;
  bool isFemale = false;
  String tier = 'Unclaassed';

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
  bool crest_booking = true;
  bool crest_score = true;
  bool crest_card = true;
  bool crest_leaderboard = true;
  bool summit_leaderboard = false;
}

Future<UserData> fetchUserDataFromFirestore() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('Climbers')
      .doc(userData.userID)
      .get();
  print("Fetching User:");
  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    print(data['userID']);
    print(data['first_name']);

    userData.firstName = data['first_name'] ?? '';
    userData.lastName = data['last_name'] ?? '';

    userData.tier = data['tier'] ?? '';
    return UserData()
      ..userID = data['userID'] ?? ''
      ..firstName = data['first_name'] ?? ''
      ..lastName = data['last_name'] ?? ''
      ..ibex = data['ibex'] ?? false
      //..isFemale = data['isFemale'] ?? false
      ..tier = data['tier'] ?? '';
  } else {
    throw Exception("User document does not exist");
  }
}

Stages stages = Stages();

Future<Stages> fetchPhasesFromFirestore() async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('event').doc('Phases').get();

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

Future<Stages> fetchStagesFromFirestore() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
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
