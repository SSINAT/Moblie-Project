import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  Future<List<Map<String, dynamic>>> fetchTopUsers() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .orderBy('totalScore', descending: true)
            .limit(10)
            .get();

    return snapshot.docs.map((doc) {
      return {
        'name': doc['name'] ?? 'No Name',
        'score': doc['totalScore'] ?? 0,
        'avatarUrl': doc['avatarUrl'] ?? '', // Optional
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Ranking',
            style: TextStyle(
            color: Colors.white,
            fontSize: 30, // Adjust the size as needed
            fontFamily: 'Kufam',
          ),
        ),
        centerTitle: true,
        
        backgroundColor: const Color.fromARGB(255, 39, 13, 232),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTopUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No leaderboard data.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      user['avatarUrl'].isNotEmpty
                          ? NetworkImage(user['avatarUrl'])
                          : null,
                  child:
                      user['avatarUrl'].isEmpty
                          ? Text(
                            user['name'].substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                          : null,
                ),
                title: Text(user['name']),
                trailing: Text(
                  '${user['score']} pts',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
