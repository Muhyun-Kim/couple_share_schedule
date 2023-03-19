import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PartnerMainScreen extends StatelessWidget {
  const PartnerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 202, 205),
        elevation: 0.0,
        title: const Text(
          "Partner Schedule",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.person_outline,
            ),
          ),
        ],
      ),
    );
  }
}
