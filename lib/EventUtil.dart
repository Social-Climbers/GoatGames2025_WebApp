import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goatgames25webapp/data.dart';

// Updates the last active timestamp for a user
Future<void> updateLastActive(String userID) async {
  CollectionReference climbers =
      FirebaseFirestore.instance.collection('Climbers');
  return climbers.doc(userID).set({
    'lastActive': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

// Updates the app version for a user
Future<void> updateAppVersion(String userID, String appVersion) async {
  CollectionReference climbers =
      FirebaseFirestore.instance.collection('Climbers');
  return climbers.doc(userID).set({
    'appVersion': appVersion,
  }, SetOptions(merge: true));
}

// Updates the session active status for a user
Future<void> updateSessionActive(bool sessionActive, String round) async {
  CollectionReference climbers =
      FirebaseFirestore.instance.collection('Climbers');
  return climbers.doc(userData.userID).set({
    'sessionData${round}': {
      'round': round,
      'sessionActive': sessionActive,
      'timestamp': FieldValue.serverTimestamp(),
    }
  }, SetOptions(merge: true));
}

// Retrieves the session active status for a user
Future<bool> getSessionActive(String round) async {
  CollectionReference climbers =
      FirebaseFirestore.instance.collection('Climbers');
  DocumentSnapshot doc = await climbers.doc(userData.userID).get();
  if (doc.exists) {
    print("Session Found");
    return doc['sessionData${round}']['sessionActive'] ?? false;
  }
  return false;
}

// Retrieves the last active timestamp for a user
Future<DocumentSnapshot> getLastActive(String userID) async {
  CollectionReference climbers =
      FirebaseFirestore.instance.collection('Climbers');
  return climbers.doc(userID).get();
}

// Retrieves the app version for a user
Future<DocumentSnapshot> getAppVersion(String userID) async {
  CollectionReference climbers =
      FirebaseFirestore.instance.collection('Climbers');
  return climbers.doc(userID).get();
}
