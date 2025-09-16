import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20), // Адаптивный отступ
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24, // Адаптивный размер шрифта
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmallScreen ? 2 : 4), // Адаптивный отступ
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14, // Адаптивный размер шрифта
              color: Colors.grey[600],
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