import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';

class LockerScreen extends StatelessWidget {
  const LockerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шкафчики'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран бронирования шкафчиков'),
      ),
    );
  }
}