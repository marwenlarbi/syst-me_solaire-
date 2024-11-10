import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  ResultScreen({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('النتيجة'),
        backgroundColor: Colors.transparent, // Transparent AppBar as in code2
        elevation: 0, // No shadow for AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpeg'), // Background image
            fit: BoxFit.cover, // Make the image cover the whole screen
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.darken), // Dark filter
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result text with shadow for contrast
              Text(
                'نتيجتك: $score / $total',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text for better visibility
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ], // Light shadow effect
                ),
              ),
              SizedBox(height: 20),
              // Button to go back to home page with the same styling as in code2
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('العودة إلى الصفحة الرئيسية'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Deep purple button
                  padding: EdgeInsets.symmetric(vertical: 15), // Padding
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
