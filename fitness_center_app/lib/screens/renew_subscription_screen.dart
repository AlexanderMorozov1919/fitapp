import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';

class RenewSubscriptionScreen extends StatelessWidget {
  const RenewSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продление абонемента'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран продления абонемента'),
      ),
    );
  }
}