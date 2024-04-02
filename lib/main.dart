import 'package:flutter/material.dart';
import 'package:task/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utibu Health App',
      home: LoginPage(), 
    );
  }
}


