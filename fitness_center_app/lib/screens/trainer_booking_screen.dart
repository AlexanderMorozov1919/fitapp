import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';

class TrainerBookingScreen extends StatefulWidget {
  final Map<String, dynamic>? trainer;

  const TrainerBookingScreen({super.key, this.trainer});

  @override
  State<TrainerBookingScreen> createState() => _TrainerBookingScreenState();
}

class _TrainerBookingScreenState extends State<TrainerBookingScreen> {

  @override
  Widget build(BuildContext context) {
    final trainer = widget.trainer ?? {
      'name': 'Тренер',
      'specialization': 'Специализация',
      'price': 2000,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронирование тренера'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Бронирование тренера: ${trainer['name']}'),
      ),
    );
  }
}