import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
       
        backgroundColor: const Color(0xFFF7F7F9),
        
        elevation: 1,
        
        automaticallyImplyLeading: false,
        
        // Left side: Logo + Text
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text(
              'MyPortfolio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: Color.fromARGB(255, 32, 38, 57),
              ),
            ),
          ],
        ),
        
        // Right side: Menu Icon
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF1A1A1A),
              size: 28,
            ),
          ),
          const SizedBox(width: 12), // A little padding on the right
        ],
      ),
      
      // 3. The Body
      body: const SafeArea(
        child: Center(
          child: Text(
            'Welcome to my portfolio!',
            style: TextStyle(color: Color.fromARGB(137, 20, 21, 29), fontSize: 16),
          ),
        ),
      ),
    );
  }
}