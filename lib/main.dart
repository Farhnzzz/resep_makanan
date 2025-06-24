import 'package:flutter/material.dart';
import 'package:resep_makanan/page/home.dart';


void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resepku',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
