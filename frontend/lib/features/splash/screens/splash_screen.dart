import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    // Premium delay for branding
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    if (mounted) {
      if (token != null && token.isNotEmpty) {
        if (role == 'consumer') {
          context.go('/consumer-dashboard');
        } else {
          context.go('/');
        }
      } else {
        context.go('/role-selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors inspired by the reference image
    const Color bgGreen = Color(0xFF7AC142);
    final Color lightShapeGreen = const Color(0xFF90D150).withValues(alpha: 0.3);

    return Scaffold(
      backgroundColor: bgGreen,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Abstract background shapes
          Positioned(
            top: -120,
            left: -80,
            child: _buildShape(320, lightShapeGreen),
          ),
          Positioned(
            top: -60,
            left: -40,
            child: _buildShape(220, lightShapeGreen),
          ),
          Positioned(
            bottom: -180,
            right: -60,
            child: _buildShape(450, lightShapeGreen),
          ),
          Positioned(
            bottom: -100,
            right: -30,
            child: _buildShape(340, lightShapeGreen),
          ),
          
          // Centered Logo and Text
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Custom Badge Logo
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(65),
                        bottomRight: Radius.circular(65),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.agriculture_rounded,
                      size: 65,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Brand Subtitle
                  Text(
                    'AGRO',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Main App Name
                  const Text(
                    'KURUKSHETRA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  // Subtle loading bar
                  SizedBox(
                    width: 50,
                    height: 2.5,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          
          // Version info
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShape(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
