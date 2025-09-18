import 'package:flutter/material.dart';

class NewsBanner {
  final String id;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final String? imageAsset;
  final String? actionText;
  final String? actionRoute;

  NewsBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    this.imageAsset,
    this.actionText,
    this.actionRoute,
  });
}