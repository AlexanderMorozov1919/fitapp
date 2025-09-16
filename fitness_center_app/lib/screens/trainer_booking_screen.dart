import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';

class TrainerBookingScreen extends StatelessWidget {
  const TrainerBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронирование тренера'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран бронирования тренера'),
      ),
    );
  }
}