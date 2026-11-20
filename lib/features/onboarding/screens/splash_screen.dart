
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color primary = Color(0xFFF15A00);
  static const Color secondary = Color(0xFFFF8500);

  late final AnimationController _floatingController;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding =
        prefs.getBool(AppConstants.onboardingKey) ?? false;

    final token = await AppConstants.storage.read(
      key: 'auth_token',
    );

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go('/home');
    } else if (!hasSeenOnboarding) {
      context.go('/onboarding');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFCFA),
              Color(0xFFFFF0E7),
              Color(0xFFFFE4D5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background decorative circles
            Positioned(
              top: -100,
              right: -90,
              child: _backgroundCircle(300),
            ),
            Positioned(
              bottom: -130,
              left: -100,
              child: _backgroundCircle(350),
            ),

            // Center content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Floating package
                AnimatedBuilder(
                  animation: _floatingController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        -10 * _floatingController.value,
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primary, secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.28),
                          blurRadius: 35,
                          offset: const Offset(0, 17),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 54,
                    ),
                  ),
                ).animate().fadeIn(duration: 700.ms).scale(
                      begin: const Offset(0.6, 0.6),
                      curve: Curves.easeOutBack,
                      duration: 900.ms,
                    ),

                const SizedBox(height: 35),

                // Brand
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'X10',
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2.5,
                        color: Color(0xFF20242C),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 4,
                      height: 37,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primary, secondary],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'SHIPPING',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                        color: primary,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 250.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 700.ms,
                    ),

                const SizedBox(height: 12),

                const Text(
                  'Your delivery. Simplified.',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.4,
                    color: Color(0xFF858B98),
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const Spacer(),

                // Loading indicator
                SizedBox(
                  width: 145,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Color(0xFFFFD9C5),
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 15),

                const Text(
                  'PREPARING YOUR EXPERIENCE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                    color: Color(0xFF858B98),
                  ),
                ),

                const SizedBox(height: 55),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFB88E).withOpacity(0.12),
      ),
    );
  }
}
