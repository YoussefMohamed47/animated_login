import 'package:flutter/material.dart';

import 'view/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animated Login',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
