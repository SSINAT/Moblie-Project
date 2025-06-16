import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_ranking.dart';
import '../services/ranking_service.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingPage> {
  final RankingService _rankingService = RankingService();
  late Future<List<UserRanking>> _rankingsFuture;
  late Future<UserRanking?> _currentUserRankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture = _rankingService.getTopRankings();
    _currentUserRankingFuture = _rankingService.getCurrentUserRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 25, 0, 255),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTopThree(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildRankingList(),
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 225, 130, 35)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Ranking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return FutureBuilder<List<UserRanking>>(
      future: _rankingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(child: Text('No ranking data available', style: TextStyle(color: Colors.white))),
          );
        }

        final rankings = snapshot.data!;
        final topThree = rankings.take(3).toList();
        
        // Ensure we have 3 items for the podium
        while (topThree.length < 3) {
          topThree.add(UserRanking(
            uid: 'placeholder-${topThree.length}',
            name: 'N/A',
            photoUrl: '',
            points: 0,
            rank: topThree.length + 1,
          ));
        }

        // Reorder for the podium (1st in center, 2nd on left, 3rd on right)
        final first = topThree.isNotEmpty ? topThree[0] : null;
        final second = topThree.length > 1 ? topThree[1] : null;
        final third = topThree.length > 2 ? topThree[2] : null;

        return Container(
          height: 220,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Second place
              _buildPodiumItem(second, 2, Colors.indigo.shade300, 80),
              
              // First place
              _buildPodiumItem(first, 1, Colors.orange, 100),
              
              // Third place
              _buildPodiumItem(third, 3, Colors.indigo.shade300, 60),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPodiumItem(UserRanking? user, int position, Color color, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (user != null) ...[
          CircleAvatar(
            radius: 30,
            backgroundImage: user.photoUrl.isNotEmpty
                ? NetworkImage(user.photoUrl)
                : AssetImage('assets/images/avatar.svg') as ImageProvider,
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 8),
          Text(
            user.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ] else ...[
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'N/A',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              position.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList() {
    return FutureBuilder<List<UserRanking>>(
      future: _rankingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading rankings'));
        }

        final rankings = snapshot.data ?? [];
        
        // Skip the top 3 for the list below
        final remainingRankings = rankings.length > 3 ? rankings.sublist(3) : [];

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: remainingRankings.length,
                itemBuilder: (context, index) {
                  final ranking = remainingRankings[index];
                  return _buildRankingListItem(ranking);
                },
              ),
            ),
            _buildCurrentUserRanking(),
          ],
        );
      },
    );
  }

  Widget _buildRankingListItem(UserRanking ranking) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                ranking.rank.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: ranking.photoUrl.isNotEmpty
                  ? NetworkImage(ranking.photoUrl)
                  : AssetImage('assets/images/avatar.png') as ImageProvider,
            ),
          ],
        ),
        title: Text(
          ranking.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.thumb_up, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              _formatPoints(ranking.points),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentUserRanking() {
    return FutureBuilder<UserRanking?>(
      future: _currentUserRankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 60,
            color: Colors.grey.shade200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final currentUserRanking = snapshot.data;
        
        if (currentUserRanking == null) {
          return Container(
            height: 60,
            color: Colors.grey.shade200,
            child: Center(child: Text('Complete a quiz to see your ranking')),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            border: Border(
              left: BorderSide(color: Colors.blue, width: 4),
            ),
          ),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    currentUserRanking.rank > 999 ? '—' : currentUserRanking.rank.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundImage: currentUserRanking.photoUrl.isNotEmpty
                      ? NetworkImage(currentUserRanking.photoUrl)
                      : AssetImage('assets/images/avatar.png') as ImageProvider,
                ),
              ],
            ),
            title: Text(
              'You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_up, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  _formatPoints(currentUserRanking.points),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      final thousands = points / 1000;
      return '${thousands.toStringAsFixed(1)}k';
    }
    return points.toString();
  }
}