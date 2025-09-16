import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final String variant;
  final IconData? icon;
  final Function()? onPressed;
  final bool small;

  const Button({
    super.key,
    required this.label,
    this.variant = 'primary',
    this.icon,
    this.onPressed,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    final Map<String, Color> variantColors = {
      'primary': Colors.blue,
      'secondary': Colors.grey,
      'success': Colors.green,
      'danger': Colors.red,
    };

    final Map<String, Color> variantTextColors = {
      'primary': Colors.white,
      'secondary': Colors.black,
      'success': Colors.white,
      'danger': Colors.white,
    };

    final color = variantColors[variant] ?? Colors.blue;
    final textColor = variantTextColors[variant] ?? Colors.white;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: small
            ? EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : 12, // Адаптивный паддинг
                vertical: isSmallScreen ? 5 : 6,
              )
            : EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 14 : 16, // Адаптивный паддинг
                vertical: isSmallScreen ? 10 : 12,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12), // Адаптивный радиус
        ),
        minimumSize: small
            ? Size(0, isSmallScreen ? 28 : 32) // Адаптивная минимальная высота
            : const Size(double.infinity, 48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: small ? (isSmallScreen ? 14 : 16) : (isSmallScreen ? 18 : 20)), // Адаптивный размер иконки
            SizedBox(width: isSmallScreen ? 6 : 8), // Адаптивный отступ
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: small ? (isSmallScreen ? 11 : 12) : (isSmallScreen ? 13 : 14), // Адаптивный размер шрифта
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}