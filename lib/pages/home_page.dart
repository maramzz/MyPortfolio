import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        
        //  wrap the image in the SAME Hero tag
        title: Row(
          children: [
            Hero(
              tag: 'logoTag', // Must match the SplashScreen exactly!
              child: Image.asset(
                'assets/images/logo.png',
                height: 32, // Lands at normal size
                width: 32,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'MyPortfolio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF1A1A1A),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      
     
      body: const SafeArea(
        child: Center(
          child: Text(
            'Welcome to my portfolio!',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ),
      ),
    );
  }
}