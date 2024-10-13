import 'package:flutter/material.dart';
import 'package:form_acquistion/login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}


