import 'package:flutter/material.dart';
import 'package:homestay2u_malaysia/screens/homestay_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homestay2U Malaysia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D0B55)),
        useMaterial3: true,
      ),
      home: const HomestayListScreen(),
    );
  }
}

 

