import 'package:flutter/material.dart';
import '../models/user_ranking.dart';
import '../services/ranking_service.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingPage> {
  final RankingService _rankingService = RankingService();
  late Stream<List<UserRanking>> _rankingsStream;

  @override
  void initState() {
    super.initState();
    _rankingsStream = _rankingService.getTopRankings();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safePadding =
        MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    final availableHeight =
        screenHeight - safePadding - kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 0, 255),
      body: Column(
        children: [
          _buildHeader(),
          _buildTopThree(availableHeight * 0.3),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding:EdgeInsets.symmetric(vertical: 40, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Center(
              
              child: Text(
                'Ranking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
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

  Widget _buildTopThree(double maxHeight) {
    return StreamBuilder<List<UserRanking>>(
      stream: _rankingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: maxHeight,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final rankings = snapshot.data ?? [];
        if (rankings.isEmpty) {
          return SizedBox(
            height: maxHeight,
            child: Center(
              child: Text(
                'No ranking data available',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final topThree = rankings.take(3).toList();
        while (topThree.length < 3) {
          topThree.add(
            UserRanking(
              uid: 'placeholder-${topThree.length}',
              name: 'N/A',
              photoUrl: '',
              stars: 0, // Changed from points to stars
              rank: topThree.length + 1,
            ),
          );
        }

        final first = topThree.isNotEmpty ? topThree[0] : null;
        final second = topThree.length > 1 ? topThree[1] : null;
        final third = topThree.length > 2 ? topThree[2] : null;

        return Container(
          height: maxHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumItem(
                second,
                2,
                Colors.indigo.shade300,
                maxHeight * 0.36,
              ),
              _buildPodiumItem(first, 1, Colors.orange, maxHeight * 0.45),
              _buildPodiumItem(
                third,
                3,
                Colors.indigo.shade300,
                maxHeight * 0.27,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPodiumItem(
    UserRanking? user,
    int position,
    Color color,
    double height,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (user != null && user.name != 'N/A') ...[
          CircleAvatar(
            radius: 30,
            backgroundImage:
                user.photoUrl.isNotEmpty
                    ? NetworkImage(user.photoUrl)
                    : const AssetImage('assets/images/avatar.svg')
                        as ImageProvider,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                _formatStars(user.stars), // Changed from points to stars
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ] else ...[
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'N/A',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              position.toString(),
              style: const TextStyle(
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
    return StreamBuilder<List<UserRanking>>(
      stream: _rankingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final rankings = snapshot.data ?? [];
        final remainingRankings =
            rankings.length > 3 ? rankings.sublist(3) : [];

        return ListView.builder(
          itemCount: remainingRankings.length,
          itemBuilder: (context, index) {
            final ranking = remainingRankings[index];
            return _buildRankingListItem(ranking);
          },
        );
      },
    );
  }

  Widget _buildRankingListItem(UserRanking ranking) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                ranking.rank.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage:
                  ranking.photoUrl.isNotEmpty
                      ? NetworkImage(ranking.photoUrl)
                      : const AssetImage('assets/images/avatar.png')
                          as ImageProvider,
            ),
          ],
        ),
        title: Text(
          ranking.name,    //star
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Color.fromARGB(255, 255, 255, 255), size: 16),
            const SizedBox(width: 4),
            Text(
              _formatStars(ranking.stars), // Changed from points to stars
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStars(int stars) {
    // Changed from _formatPoints to _formatStars
    if (stars >= 1000) {
      final thousands = stars / 1000;
      return '${thousands.toStringAsFixed(1)}k';
    }
    return stars.toString();
  }
}

const double kBottomNavigationBarHeight = 56.0;
