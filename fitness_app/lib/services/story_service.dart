import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/story_model.dart';

class StoryService with ChangeNotifier {
  final Map<String, StoryProgress> _viewedStories = {};

  bool isStoryViewed(String storyId) {
    return _viewedStories[storyId]?.isViewed ?? false;
  }

  void markStoryAsViewed(String storyId) {
    _viewedStories[storyId] = StoryProgress(
      storyId: storyId,
      isViewed: true,
      viewedAt: DateTime.now(),
    );
    // Откладываем уведомление до завершения кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void markStoryAsUnviewed(String storyId) {
    _viewedStories.remove(storyId);
    // Откладываем уведомление до завершения кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int get viewedStoriesCount {
    return _viewedStories.values.where((progress) => progress.isViewed).length;
  }

  int get totalStoriesCount {
    // Это значение будет обновляться при загрузке сториз
    return _viewedStories.length;
  }

  void clearAllProgress() {
    _viewedStories.clear();
    // Откладываем уведомление до завершения кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Для сохранения и восстановления состояния
  Map<String, dynamic> toJson() {
    return {
      'viewedStories': _viewedStories.map((key, value) => 
        MapEntry(key, value.toJson())),
    };
  }

  void fromJson(Map<String, dynamic> json) {
    final viewedStories = json['viewedStories'] as Map<String, dynamic>?;
    if (viewedStories != null) {
      _viewedStories.clear();
      viewedStories.forEach((key, value) {
        _viewedStories[key] = StoryProgress.fromJson(value);
      });
    }
    // Откладываем уведомление до завершения кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}