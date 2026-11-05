import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9ED),
      appBar: AppBar(
        title: const Text(
          'Fatflix',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF702D45),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_filter_rounded,
                size: 80,
                color: Color(0xFF702D45),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to Fatflix',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF702D45),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You are logged in.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB85C75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}