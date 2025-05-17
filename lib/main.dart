import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(const MoodJournalApp());
}

class MoodJournalApp extends StatelessWidget {
  const MoodJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Journal',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigation(), // Updated to use the MainNavigation
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _screens = [
    HomeScreen(), // Home screen with quotes
    NewEntryScreen(), // Placeholder for New Entry Screen
    StatsScreen(), // Placeholder for Stats Screen
    SettingsScreen(), // Placeholder for Settings Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Dynamically show the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'New Entry'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMood;
  String _quote = "Loading quote..."; // Default quote

  @override
  void initState() {
    super.initState();
    fetchQuote(); // Fetch the quote when the screen is loaded
  }

  Future<void> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse('https://type.fit/api/quotes'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final now = DateTime.now();
        final index = (now.hour ~/ 6) % data.length;

        setState(() {
          _quote = data[index]['text']; // Update quote
        });
      } else {
        setState(() {
          _quote = "Couldn't load quote 😞"; // If the API fails
        });
      }
    } catch (e) {
      setState(() {
        _quote = "Couldn't load quote 😞"; // Handle error
      });
    }
  }

  void _setMood(String label) {
    setState(() {
      _selectedMood = label;
    });

    Navigator.pop(context); // Close the bottom sheet

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mood logged: $label"),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.pink[300],
      ),
    );
  }

  void _showMoodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Your Mood",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink[800],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _moodButton("😊", "Happy"),
                  _moodButton("😐", "Neutral"),
                  _moodButton("😢", "Sad"),
                  _moodButton("😡", "Angry"),
                  _moodButton("😖", "Frustrated")
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _moodButton(String emoji, String label) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _setMood(label),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              shape: BoxShape.circle,
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi Mekdes 👋",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pink[800],
              ),
            ),
            Text(
              "Today is $today",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "How are you feeling today?",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedMood != null)
              Center(
                child: Text(
                  "Your recent mood: $_selectedMood",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.pink[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                _quote,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMoodSelector,
        icon: const Icon(Icons.emoji_emotions_outlined),
        label: const Text("Log Mood"),
        backgroundColor: Colors.pink[300],
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class NewEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('New Entry Screen')),
    );
  }
}

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Stats Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Settings Screen')),
    );
  }
}
