import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 187, 255, 1),
      body: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 50,
            color: Colors.white,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText("Loading..."),
            ],
          ),
        ),
      ),
    );
  }
}
