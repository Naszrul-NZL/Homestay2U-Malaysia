import 'package:flutter/material.dart';
import 'package:homestay2u_malaysia/screens/homestay_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomestayListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D0B55),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.home,
                size: 64,
                color: Color(0xFF2D0B55),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Homestay2U',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Malaysia',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Color(0xFFFFD700),
            ),
          ],
        ),
      ),
    );
  }
}