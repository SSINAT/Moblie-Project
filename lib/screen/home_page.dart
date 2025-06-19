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
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
    _fetchQuizHistory();
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      if (currentUser != null && mounted) {
        setState(() {
          user = currentUser;
          _fetchUserData();
        });
      }
    });
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
      setState(() {
        userName =
            userDoc['name'] ??
            user!.displayName ??
            user!.email?.split('@')[0] ??
            'Unknown';
      });
    }
  }

  Future<void> _fetchQuizHistory() async {
    try {
      if (user != null) {
        final attemptsSnapshot =
            await FirebaseFirestore.instance
                .collection('scores')
                .where('userId', isEqualTo: user!.uid)
                .orderBy('timestamp', descending: true)
                .get();
        final List<Map<String, dynamic>> loadedHistory =
            attemptsSnapshot.docs.map((doc) {
              final data = doc.data();
              final timestamp = data['timestamp'];
              return {
                'date':
                    timestamp is Timestamp
                        ? timestamp.toDate().toString()
                        : 'No date',
                'score': data['score'] != null ? '${data['score']}/100' : 'N/A',
              };
            }).toList();

        if (mounted) {
          setState(() {
            historyData = loadedHistory;
          });
        }
      }
    } catch (e) {
      print('Error fetching quiz history: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
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
                                  user?.photoURL ??
                                      'https://via.placeholder.com/40',
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.person,
                                            color: Color.fromARGB(
                                              255,
                                              157,
                                              16,
                                              16,
                                            ),
                                          ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                userName,
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
                          color: const Color.fromARGB(255, 70, 51, 236),
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
                                            ? const Color.fromARGB(
                                              255,
                                              51,
                                              3,
                                              244,
                                            )
                                            : const Color.fromARGB(
                                              255,
                                              70,
                                              51,
                                              236,
                                            ),
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
                                            ? const Color.fromARGB(
                                              255,
                                              22,
                                              6,
                                              238,
                                            )
                                            : const Color.fromARGB(
                                              255,
                                              70,
                                              51,
                                              236,
                                            ),
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
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF0D1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _showCurrent
                                ? Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                'You have attempted a\ntotal ',
                                          ),
                                          TextSpan(
                                            text: '${historyData.length}',
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
                                            value:
                                                historyData.isNotEmpty
                                                    ? historyData.length / 50
                                                    : 0,
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
                                              children: [
                                                Text(
                                                  historyData.isNotEmpty
                                                      ? historyData[0]['score']
                                                      : '0',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Text(
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
                                : Column(
                                  children: [
                                    ...historyData.map(
                                      (item) => Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEED6A7),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                      ),
                                    ),
                                  ],
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryItem(
                    'C++',
                    Colors.green,
                    'assets/cpp_logo.png',
                    () {
                      print('C++ category tapped');
                    },
                  ),
                  _buildCategoryItem(
                    'Java',
                    Colors.blue[300]!,
                    'assets/java_logo.png',
                    () {
                      print('Java category tapped');
                    },
                  ),
                  _buildCategoryItem(
                    'HTML',
                    Colors.orange,
                    'assets/html_logo.png',
                    () {
                      print('HTML category tapped');
                    },
                  ),
                  _buildCategoryItem(
                    'Python',
                    Colors.blue,
                    'assets/python_logo.png',
                    () {
                      print('Python category tapped');
                    },
                  ),
                ],
              ),
            ],
          ),
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
            child: Center(child: _getCategoryImage(title, color)),
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

  Widget _getCategoryImage(String category, Color color) {
    switch (category) {
      case 'C++':
        return Container(
          padding: const EdgeInsets.all(8),
          child: CustomPaint(
            size: const Size(30, 30),
            painter: CPlusPlusPainter(color),
          ),
        );
      case 'Java':
        return Container(
          padding: const EdgeInsets.all(8),
          child: CustomPaint(
            size: const Size(30, 30),
            painter: JavaPainter(color),
          ),
        );
      case 'HTML':
        return Container(
          padding: const EdgeInsets.all(5),
          child: CustomPaint(
            size: const Size(30, 30),
            painter: HTMLPainter(Colors.orange),
          ),
        );
      case 'Python':
        return Container(
          padding: const EdgeInsets.all(5),
          child: CustomPaint(
            size: const Size(30, 30),
            painter: PythonPainter(Colors.blue),
          ),
        );
      default:
        return Icon(Icons.code, color: color, size: 30);
    }
  }
}

class CPlusPlusPainter extends CustomPainter {
  final Color color;
  CPlusPlusPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final textStyle = TextStyle(
      color: color,
      fontSize: size.height * 0.8,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: 'C++', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JavaPainter extends CustomPainter {
  final Color color;
  JavaPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    final cup =
        Path()
          ..moveTo(size.width * 0.3, size.height * 0.3)
          ..lineTo(size.width * 0.3, size.height * 0.7)
          ..lineTo(size.width * 0.7, size.height * 0.7)
          ..lineTo(size.width * 0.7, size.height * 0.3);
    final handle =
        Path()
          ..moveTo(size.width * 0.7, size.height * 0.4)
          ..quadraticBezierTo(
            size.width * 0.9,
            size.height * 0.4,
            size.width * 0.9,
            size.height * 0.5,
          )
          ..quadraticBezierTo(
            size.width * 0.9,
            size.height * 0.6,
            size.width * 0.7,
            size.height * 0.6,
          );
    final steam =
        Path()
          ..moveTo(size.width * 0.4, size.height * 0.3)
          ..quadraticBezierTo(
            size.width * 0.4,
            size.height * 0.1,
            size.width * 0.5,
            size.height * 0.1,
          )
          ..quadraticBezierTo(
            size.width * 0.6,
            size.height * 0.1,
            size.width * 0.6,
            size.height * 0.3,
          );
    canvas.drawPath(cup, paint);
    canvas.drawPath(handle, paint);
    canvas.drawPath(steam, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HTMLPainter extends CustomPainter {
  final Color color;
  HTMLPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path =
        Path()
          ..moveTo(size.width * 0.1, 0)
          ..lineTo(size.width * 0.9, 0)
          ..lineTo(size.width * 0.8, size.height)
          ..lineTo(size.width * 0.5, size.height * 0.9)
          ..lineTo(size.width * 0.2, size.height)
          ..close();
    canvas.drawPath(path, paint);
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: size.height * 0.5,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(text: '5', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PythonPainter extends CustomPainter {
  final Color color;
  PythonPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path1 =
        Path()
          ..moveTo(size.width * 0.3, size.height * 0.1)
          ..quadraticBezierTo(
            size.width * 0.1,
            size.height * 0.2,
            size.width * 0.3,
            size.height * 0.4,
          )
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height * 0.6,
            size.width * 0.3,
            size.height * 0.8,
          )
          ..quadraticBezierTo(
            size.width * 0.1,
            size.height * 0.9,
            size.width * 0.3,
            size.height,
          );
    final path2 =
        Path()
          ..moveTo(size.width * 0.7, size.height)
          ..quadraticBezierTo(
            size.width * 0.9,
            size.height * 0.8,
            size.width * 0.7,
            size.height * 0.6,
          )
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height * 0.4,
            size.width * 0.7,
            size.height * 0.2,
          )
          ..quadraticBezierTo(
            size.width * 0.9,
            size.height * 0.1,
            size.width * 0.7,
            0,
          );
    canvas.drawPath(path1, paint);
    paint.color = Colors.yellow;
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
