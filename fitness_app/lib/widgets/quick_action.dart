import 'package:flutter/material.dart';

class QuickAction extends StatelessWidget {
  final IconData icon;
  final Function() onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}