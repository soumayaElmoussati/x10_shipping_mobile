import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF15A00);
  static const Color primaryDark = Color(0xFFE04F00);
  static const Color primaryLight = Color(0xFFFF8500);

  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Colors.white;

  static const Color text = Color(0xFF20242C);
  static const Color textSecondary = Color(0xFF858B98);
  static const Color border = Color(0xFFE8EAF0);

  static const Color success = Color(0xFF16A36A);
  static const Color warning = Color(0xFFF0A020);
  static const Color error = Color(0xFFE54848);
  static const Color info = Color(0xFF3488D8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primary,
      primaryLight,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}