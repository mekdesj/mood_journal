import 'package:flutter/material.dart';

class NewEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Write a new entry 📝',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
