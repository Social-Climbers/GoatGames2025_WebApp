import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasecampLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Basecamp Leaderboard')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
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

          List<DocumentSnapshot> silverhornUsers =
              snapshot.data!.docs
                  .where((doc) => doc['category'] == 'silverhorn')
                  .toList();
          List<DocumentSnapshot> ibexUsers =
              snapshot.data!.docs
                  .where((doc) => doc['category'] == 'ibex')
                  .toList();

          return ListView(
            children: [
              _buildCategoryLabel('Silverhorn'),
              ...silverhornUsers.map(
                (doc) => ListTile(
                  title: Text(doc['name']),
                  subtitle: Text('Points: ${doc['points']}'),
                ),
              ),
              _buildCategoryLabel('Ibex'),
              ...ibexUsers.map(
                (doc) => ListTile(
                  title: Text(doc['name']),
                  subtitle: Text('Points: ${doc['points']}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryLabel(String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        category,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
