import 'package:final_project_debojyoti_64_g_306/homepage.dart';
import 'package:final_project_debojyoti_64_g_306/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fatflix',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFE4F5F2)),
      home: const LoginPage(),
    );
  }
}


