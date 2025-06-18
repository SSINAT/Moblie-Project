import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showCurrent = true;
  User? user;
  String userName = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      setState(() {
        userName = userDoc['name'] ?? '';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSegmentTapped(bool isCurrent) {
    setState(() {
      _showCurrent = isCurrent;
    });
  }

  // History quiz attempts data
  final List<Map<String, dynamic>> historyData = [
    {'date': '12/01/2025', 'score': '10/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
    {'date': '12/01/2025', 'score': '20/50'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 20,
                              child: Image.network(
                                'https://via.placeholder.com/40',
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              userName ?? 'Guest',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.notifications_outlined, size: 24),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _onSegmentTapped(true),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _showCurrent
                                          ? Colors.blue
                                          : Colors.blue[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Current',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _onSegmentTapped(false),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      !_showCurrent
                                          ? Colors.blue
                                          : Colors.blue[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'History',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF0D1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          _showCurrent
                              ?
                              // Current view with progress circle
                              Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'You have attempted a\ntotal ',
                                        ),
                                        TextSpan(
                                          text: '40',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: ' '),
                                        TextSpan(
                                          text: 'quizzes',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: ' !'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CircularProgressIndicator(
                                          value: 40 / 50,
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Colors.green),
                                          strokeWidth: 10,
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                '40',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '/50',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                'quiz played',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                              :
                              // History view with scrollable list of attempts
                              SizedBox(
                                height:
                                    300, // Fixed height for the scrollable area
                                child: ListView.builder(
                                  itemCount: historyData.length,
                                  itemBuilder: (context, index) {
                                    final item = historyData[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEED6A7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Date: ${item['date']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item['score'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Featured Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryItem('C++', Colors.green, 'assets/cpp.png', () {
                  print('C++ category tapped');
                  // Add navigation logic for C++ category
                }),
                _buildCategoryItem(
                  'Java',
                  Colors.blue[300]!,
                  'assets/java.png',
                  () {
                    print('Java category tapped');
                    // Add navigation logic for Java category
                  },
                ),
                _buildCategoryItem(
                  'HTML',
                  Colors.orange,
                  'assets/html.png',
                  () {
                    print('HTML category tapped');
                    // Add navigation logic for HTML category
                  },
                ),
                _buildCategoryItem(
                  'Python',
                  Colors.blue,
                  'assets/python.png',
                  () {
                    print('Python category tapped');
                    // Add navigation logic for Python category
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    String title,
    Color color,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: _getCategoryImage(title, imagePath)),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryImage(String category, String imagePath) {
    // Using PNG assets for programming language logos
    return Image.asset(
      imagePath,
      width: 30,
      height: 30,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if image fails to load
        return Icon(
          _getCategoryIcon(category),
          size: 30,
          color: _getCategoryColor(category),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'C++':
        return Colors.green;
      case 'Java':
        return Colors.blue[300]!;
      case 'HTML':
        return Colors.orange;
      case 'Python':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'C++':
        return Icons.code;
      case 'Java':
        return Icons.coffee;
      case 'HTML':
        return Icons.html;
      case 'Python':
        return Icons.integration_instructions;
      default:
        return Icons.category;
    }
  }
}
