import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4361EE);
  static const Color primaryDark = Color(0xFF3A56D4);
  static const Color secondary = Color(0xFF7209B7);
  static const Color success = Color(0xFF4CC9F0);
  static const Color warning = Color(0xFFF72585);
  static const Color danger = Color(0xFFE63946);
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark = Color(0xFF212529);
  static const Color gray = Color(0xFF6C757D);
  static const Color border = Color(0xFFDEE2E6);
  static const Color cardBg = Colors.white;
  static const Color statusConfirmed = Color(0xFF4CAF50);
  static const Color statusPending = Color(0xFFFFC107);
  static const Color statusCancelled = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color error = Color(0xFFE63946);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF5F7FF),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: dark,
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: dark,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: dark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: dark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: gray,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: gray,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: cardBg,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        buttonColor: primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFBFF),
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }

  static Gradient get primaryGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, primaryDark],
    );
  }

  static Gradient get secondaryGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, secondary],
    );
  }

  static Gradient get successGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
    );
  }

  static Gradient get warningGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [warning, Color(0xFFC11255)],
    );
  }

  static Gradient get dangerGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [danger, Color(0xFFB0000F)],
    );
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: Colors.black.withOpacity(0.05),
        width: 1,
      ),
    );
  }

  static BoxDecoration get buttonDecoration {
    return BoxDecoration(
      gradient: primaryGradient,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get outlineButtonDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: primary, width: 2),
    );
  }
}