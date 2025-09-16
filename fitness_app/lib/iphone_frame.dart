import 'package:flutter/material.dart';

class IPhoneFrame extends StatelessWidget {
  final Widget child;

  const IPhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Адаптивные размеры iPhone фрейма
    final frameWidth = screenWidth * 0.9 > 375 ? 375.0 : screenWidth * 0.9;
    final frameHeight = frameWidth * (812 / 375); // Сохраняем пропорции iPhone
    
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Center(
        child: Container(
          width: frameWidth,
          height: frameHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.grey[800]!,
              width: 12,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  // Основное содержимое с учетом безопасной зоны
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 44, // Отступ под статус бар
                        bottom: 34, // Отступ под навигацию
                      ),
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          size: Size(frameWidth - 24, frameHeight - 78), // Учитываем отступы
                        ),
                        child: child,
                      ),
                    ),
                  ),
                  
                  // Верхний статус бар
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 44,
                      color: Colors.black.withOpacity(0.9),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '9:41',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Icon(Icons.wifi, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Icon(Icons.battery_std, size: 14, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Нижняя безопасная зона
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 34,
                      color: Colors.transparent,
                    ),
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