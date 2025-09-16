import 'package:flutter/material.dart';

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static Curve get easeInOut => Curves.easeInOut;
  static Curve get bounceOut => Curves.bounceOut;
  static Curve get elasticOut => Curves.elasticOut;

  static Animation<double> fadeIn(AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  static Animation<double> slideUp(AnimationController controller) {
    return Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
  }

  static Animation<double> scale(AnimationController controller) {
    return Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );
  }

  static Widget buildAnimatedContainer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget buildFadeTransition({
    required AnimationController controller,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fadeIn(controller),
      child: child,
    );
  }

  static Widget buildSlideTransition({
    required AnimationController controller,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }

  static Widget buildScaleTransition({
    required AnimationController controller,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }

  static void shakeAnimation(AnimationController controller) {
    controller.forward(from: 0);
  }

  static Animation<double> createShakeAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 10, end: -5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -5, end: 5), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 5, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }
}