import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.music_note, size: 90),
            SizedBox(height: 10),
            Text('ConcerTix', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 14),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
