import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBg = Color(0xFF0F0C29);
  static const Color secondaryBg = Color(0xFF302B63);
  static const Color accent = Color(0xFF8E2DE2);
  static const Color glassmorphism = Color(0x33FFFFFF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color error = Colors.redAccent;
  static const Color success = Colors.greenAccent;
}

final BoxDecoration glassBoxDecoration = BoxDecoration(
  color: AppColors.glassmorphism,
  borderRadius: BorderRadius.circular(15),
  border: Border.all(color: Colors.white24, width: 1.5),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 10,
      spreadRadius: 2,
    )
  ],
);
