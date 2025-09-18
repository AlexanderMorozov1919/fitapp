import 'package:flutter/material.dart';
import '../../models/story_model.dart';

class StoryData {
  static final List<Story> stories = [
    // Теннисные новости (50% контента)
    Story(
      id: 'story-1',
      title: 'Турнир по теннису',
      description: '18 сентября стартует ежегодный турнир по теннису. Призы для победителей!',
      imageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400',
      backgroundColor: const Color(0xFF2196F3),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: StoryType.news,
    ),
    Story(
      id: 'story-2',
      title: 'Скидка на корты 30%',
      description: 'Только в сентябре скидка 30% на аренду теннисных кортов в вечернее время.',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      backgroundColor: const Color(0xFF4CAF50),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      type: StoryType.promotion,
    ),
    Story(
      id: 'story-3',
      title: 'Мастер-класс с про',
      description: '19 сентября мастер-класс от профессионального теннисиста. Регистрация открыта!',
      imageUrl: 'https://images.unsplash.com/photo-1595341888016-a392ef81b7de?w=400',
      backgroundColor: const Color(0xFFFF9800),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      type: StoryType.event,
    ),
    Story(
      id: 'story-4',
      title: 'Новые ракетки',
      description: 'Поступили новые профессиональные ракетки Wilson и Babolat. Тестируйте бесплатно!',
      imageUrl: 'https://images.unsplash.com/photo-1622279457486-3a6c79c7c17f?w=400',
      backgroundColor: const Color(0xFFE91E63),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: StoryType.news,
    ),

    // Общий фитнес контент (50%)
    Story(
      id: 'story-5',
      title: 'Рекорд в жиме лежа',
      description: 'Установлен новый рекорд клуба - 180 кг! Поздравляем нашего чемпиона!',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400',
      backgroundColor: const Color(0xFF9C27B0),
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      type: StoryType.achievement,
    ),
    Story(
      id: 'story-6',
      title: 'Детская секция',
      description: 'Набор в детскую теннисную секцию для детей от 7 лет. Первое занятие бесплатно!',
      imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400',
      backgroundColor: const Color(0xFF00BCD4),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: StoryType.news,
    ),
    Story(
      id: 'story-7',
      title: 'Бесплатные уроки',
      description: '20 сентября бесплатные уроки тенниса для начинающих. Записывайтесь заранее!',
      imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400',
      backgroundColor: const Color(0xFF607D8B),
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      type: StoryType.promotion,
    ),
    Story(
      id: 'story-8',
      title: 'Теннисный лагерь',
      description: 'Набор в зимний теннисный лагерь в Сочи. Раннее бронирование со скидкой 20%.',
      imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400',
      backgroundColor: const Color(0xFFFF5722),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      type: StoryType.event,
    ),
  ];

  static List<Story> getActiveStories() {
    final now = DateTime.now();
    // Для тестирования показываем все сторизы, независимо от даты
    return stories;
    // return stories.where((story) => story.createdAt.isAfter(now.subtract(const Duration(days: 7)))).toList();
  }

  static Story? getStoryById(String id) {
    try {
      return stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Story> getStoriesByType(StoryType type) {
    return stories.where((story) => story.type == type).toList();
  }
}