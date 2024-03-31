import 'package:flutter/material.dart';
import 'package:task/medicine_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Utibu Health App',
      home: MedicineListPage(),
    );
  }
}

