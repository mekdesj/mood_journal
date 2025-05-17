import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
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

  // Fetch a random quote from the API
  Future<void> fetchQuote() async {
    try {
      final response =
          await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _quote = '${data[0]['q']} \n\n– ${data[0]['a']}';
        });
      } else {
        setState(() {
          _quote = "Couldn't load quote 😞";
        });
      }
    } catch (e) {
      setState(() {
        _quote = "Couldn't load quote 😞";
      });
    }
  }

  // Auto-refresh the quote every 6 hours (21600 seconds)
  void startQuoteRefreshTimer() {
    Timer.periodic(const Duration(hours: 6), (timer) {
      fetchQuote();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuote(); // Fetch the quote initially when the screen loads
    startQuoteRefreshTimer(); // Start the timer to refresh quote every 6 hours
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
            // Display the quote here
            Center(
              child: Text(
                "\"$_quote\"",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.pink[600],
                ),
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

  // Existing method to display the mood selector
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

  // Existing method to show the mood selector
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

  // Existing method to create the mood buttons
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
}
