import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SimplePhoneBorder extends StatelessWidget {
  final Widget child;

  const SimplePhoneBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    // Простая чистая рамка без лишних деталей
    return Center(
      child: Container(
        width: 390,
        height: 844,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: child,
          ),
        ),
      ),
    );
  }
}