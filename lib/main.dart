import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the Buku model

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
