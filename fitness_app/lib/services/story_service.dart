import 'package:flutter/foundation.dart';
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
    notifyListeners();
  }

  void markStoryAsUnviewed(String storyId) {
    _viewedStories.remove(storyId);
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }
}