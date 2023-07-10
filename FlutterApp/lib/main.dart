import 'package:flutter/material.dart';
import 'package:text_recognition/homeScreen.dart';
import 'package:text_recognition/loadScreen.dart';
import 'package:text_recognition/resultSCreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        body: FrontPage(),
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/result': (context) => ResultScreen(),
      },
    );
  }
}
