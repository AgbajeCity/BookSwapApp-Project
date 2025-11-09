import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the actual login screen

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F), // Dark background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Logo and Main Text
              Column(
                children: [
                  const SizedBox(height: 100),
                  // The icon from the mockup
                  const Icon(
                    Icons.menu_book,
                    size: 80,
                    color: Color(0xFFF2C94C),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'BookSwap',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Swap Your Books\nWith Other Students',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[400],
                        ),
                  ),
                ],
              ),

              // 2. Sign In Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Sign in to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the Login Screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (ctx) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2C94C),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: const Text('Sign In',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
