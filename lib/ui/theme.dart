import 'package:flutter/material.dart';

/// Light navy/gold theme shared across the bill apps.
class BillTheme {
  static const navy = Color(0xFF1A237E);
  static const navyDark = Color(0xFF0D1330);
  static const gold = Color(0xFFFFD54F);
  static const goldDark = Color(0xFFFFA000);
  static const bg = Color(0xFFF6F8FF);

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          secondary: goldDark,
        ),
        scaffoldBackgroundColor: bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      );
}

/// Glossy 3D-style gold gradient button.
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GoldButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [BillTheme.gold, BillTheme.goldDark],
        ),
        boxShadow: [
          BoxShadow(
            color: BillTheme.goldDark.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Color(0x80000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
