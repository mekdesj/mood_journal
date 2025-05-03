import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget {
  // Sample mood data for the chart (replace with real data)
  final List<double> weeklyMoodData = [3, 4, 2, 5, 4, 3, 4]; // 1-5 scale
  final List<String> recentEntries = [
    "Had a great day with friends!",
    "Felt anxious about the meeting",
    "Peaceful morning walk"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.pink[50]!.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.pink[100]!.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                _buildHeader(),
                SizedBox(height: 32),

                // Mood check-in prompt
                _buildMoodCheckIn(context),
                SizedBox(height: 40),

                // Mood graph
                _buildMoodGraph(),
                SizedBox(height: 30),

                // Recent entries
                _buildRecentEntries(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMoodSelector(context),
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.pink[300],
        elevation: 4,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, Sarah!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.pink[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Today, ${DateTime.now().toString().split(' ')[0]}",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "\"Every day is a fresh start.\"",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.pink[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodCheckIn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How are you feeling today?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.pink[800],
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _moodButton("😊", "Happy", Colors.pink[100]!),
            _moodButton("😐", "Neutral", Colors.pink[200]!),
            _moodButton("😢", "Sad", Colors.pink[300]!),
            _moodButton("😡", "Angry", Colors.pink[400]!),
          ],
        ),
      ],
    );
  }

  Widget _moodButton(String emoji, String label, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: bgColor.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Mood This Week",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.pink[800],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 150,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomPaint(
            painter: _MoodGraphPainter(weeklyMoodData),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Entries",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.pink[800],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "View All",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...recentEntries
            .map((entry) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined, color: Colors.pink[200]),
                    title: Text(entry),
                    tileColor: Colors.pink[50]!.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  void _showMoodSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Your Mood",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink[800],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _moodSelectionButton("😊", "Happy"),
                  _moodSelectionButton("😐", "Neutral"),
                  _moodSelectionButton("😢", "Sad"),
                  _moodSelectionButton("😡", "Angry"),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _moodSelectionButton(String emoji, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.pink[100],
          child: Text(
            emoji,
            style: TextStyle(fontSize: 28),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

// Simple graph painter (replace with a proper chart library in production)
class _MoodGraphPainter extends CustomPainter {
  final List<double> data;

  _MoodGraphPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink[300]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.pink[300]!.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    final widthPerPoint = size.width / (data.length - 1);
    final heightPerPoint = size.height / 5;

    for (int i = 0; i < data.length; i++) {
      final x = i * widthPerPoint;
      final y = size.height - (data[i] * heightPerPoint);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Close path for fill
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.pink[400]!
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
