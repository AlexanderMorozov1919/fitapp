import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String status;
  final String visits;
  final String goal;
  final String days;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.status,
    required this.visits,
    required this.goal,
    this.days = '0',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.lightBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16), // Адаптивный радиус
      ),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20), // Адаптивный паддинг
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20), // Адаптивный отступ
      child: Column(
        children: [
          Container(
            width: isSmallScreen ? 60 : 80, // Адаптивный размер аватара
            height: isSmallScreen ? 60 : 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 30 : 40),
            ),
            child: Center(
              child: Text(
                name.split(' ').map((n) => n[0]).take(2).join(), // Динамические инициалы
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 24, // Адаптивный размер шрифта
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16), // Адаптивный отступ
          Text(
            name,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20, // Адаптивный размер шрифта
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmallScreen ? 2 : 4), // Адаптивный отступ
          Text(
            status,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14, // Адаптивный размер шрифта
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16), // Адаптивный отступ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(visits, 'Посещений', isSmallScreen),
              _buildStatItem('$goal%', 'Цель', isSmallScreen),
              _buildStatItem(days, 'Дней', isSmallScreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 18, // Адаптивный размер шрифта
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isSmallScreen ? 2 : 4), // Адаптивный отступ
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 10 : 12, // Адаптивный размер шрифта
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}