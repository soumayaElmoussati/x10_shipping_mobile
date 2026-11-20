import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConstants {
  static const String appName = 'X10 Shipping';

  static const String logoPath =
      'assets/images/logo_x10_shipping.jpeg';

  static const String onboardingKey = 'onboarding_completed';

  static const FlutterSecureStorage storage =
      FlutterSecureStorage();

  static const String customerRole = 'customer';
}