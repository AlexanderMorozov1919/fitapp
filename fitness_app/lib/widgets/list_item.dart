import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String avatar;
  final String title;
  final String subtitle;
  final Widget? meta;
  final Function()? onTap;

  const ListItem({
    super.key,
    required this.avatar,
    required this.title,
    required this.subtitle,
    this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10), // Уменьшенный паддинг
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 40 : 48, // Адаптивный размер аватара
              height: isSmallScreen ? 40 : 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
              ),
              child: Center(
                child: Text(
                  avatar,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16, // Адаптивный размер шрифта
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16), // Адаптивный отступ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16, // Адаптивный размер шрифта
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Уменьшенный отступ
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14, // Адаптивный размер шрифта
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (meta != null) ...[
              SizedBox(width: isSmallScreen ? 6 : 8), // Адаптивный отступ
              meta!,
            ],
          ],
        ),
      ),
    );
  }
}