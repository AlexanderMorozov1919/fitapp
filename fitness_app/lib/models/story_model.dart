import 'package:flutter/material.dart';

class Story {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Color backgroundColor;
  final Duration duration;
  final DateTime createdAt;
  final StoryType type;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.backgroundColor = Colors.blue,
    this.duration = const Duration(seconds: 10),
    required this.createdAt,
    this.type = StoryType.news,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      backgroundColor: Color(json['backgroundColor']),
      duration: Duration(seconds: json['duration']),
      createdAt: DateTime.parse(json['createdAt']),
      type: StoryType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'backgroundColor': backgroundColor.value,
      'duration': duration.inSeconds,
      'createdAt': createdAt.toIso8601String(),
      'type': type.index,
    };
  }
}

enum StoryType {
  news,       // Новости фитнес-центра
  promotion,  // Акции и скидки
  event,      // События и мероприятия
  training,   // Новые тренировки
  achievement // Достижения клуба
}

class StoryProgress {
  final String storyId;
  final bool isViewed;
  final DateTime viewedAt;

  StoryProgress({
    required this.storyId,
    this.isViewed = false,
    required this.viewedAt,
  });

  factory StoryProgress.fromJson(Map<String, dynamic> json) {
    return StoryProgress(
      storyId: json['storyId'],
      isViewed: json['isViewed'],
      viewedAt: DateTime.parse(json['viewedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'isViewed': isViewed,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }
}