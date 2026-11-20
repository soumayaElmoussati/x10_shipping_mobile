import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';

import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/reset_password_screen.dart';
import '../features/authentication/screens/verify_account_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/support/screens/support_tickets_screen.dart';
import '../features/shipments/screens/shipments_screen.dart';
import '../features/shipments/screens/create_shipment_screen.dart';
import '../features/tracking/screens/track_shipments_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/profile/screens/profile_screen.dart';

import '../core/constants/app_constants.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
  path: '/verify-account',
  builder: (context, state) => const VerifyAccountScreen(),
),
      GoRoute(
       path: '/home',
       builder: (context, state) => const DashboardScreen(),
     ),

GoRoute(
  path: '/support',
  builder: (context, state) => const SupportTicketsScreen(),
),

GoRoute(
  path: '/shipments',
  builder: (context, state) => const ShipmentsScreen(),
),
GoRoute(
  path: '/create-shipment',
  builder: (context, state) => const CreateShipmentScreen(),
),
GoRoute(
  path: '/tracking',
  builder: (context, state) => const TrackShipmentsScreen(),
),

GoRoute(
  path: '/tracking/:trackingNumber',
  builder: (context, state) {
    final trackingNumber =
        state.pathParameters['trackingNumber'];

    return TrackShipmentsScreen(
      initialTrackingNumber: trackingNumber,
    );
  },
),

GoRoute(
  path: '/notifications',
  builder: (context, state) => const NotificationsScreen(),
),

GoRoute(
  path: '/profile',
  builder: (context, state) => const ProfileScreen(),
),

    ],
  );
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('X10 Shipping'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AppConstants.storage.delete(key: 'auth_token');
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to X10 Shipping!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}