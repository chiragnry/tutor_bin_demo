import 'package:flutter/material.dart';
import 'package:untitled/screens/home_page.dart';

import 'constants/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo app',
      theme: ThemeData(
        primarySwatch: mainColor,
      ),
      home: const HomePage(),
    );
  }
}
