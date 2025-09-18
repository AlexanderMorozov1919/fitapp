import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/story_model.dart';
import '../../services/mock_data/story_data.dart';
import '../../services/story_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../main.dart';

class StoryViewScreen extends StatefulWidget {
  final String initialStoryId;
  final List<Story> stories;

  const StoryViewScreen({
    super.key,
    required this.initialStoryId,
    required this.stories,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.stories.indexWhere((story) => story.id == widget.initialStoryId);
    if (_currentIndex == -1) _currentIndex = 0;

    _pageController = PageController(initialPage: _currentIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: widget.stories[_currentIndex].duration,
    )..addStatusListener(_handleAnimationStatus);

    _startProgressAnimation();
  }

  void _startProgressAnimation() {
    if (!_isPaused) {
      _progressController.forward(from: 0);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Помечаем текущий сториз как просмотренный
      _markCurrentStoryAsViewed();
      _goToNextStory();
    }
  }

  void _markCurrentStoryAsViewed() {
    final storyService = Provider.of<StoryService>(context, listen: false);
    final currentStory = widget.stories[_currentIndex];
    storyService.markStoryAsViewed(currentStory.id);
  }

  void _goToNextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _closeStoryView();
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _closeStoryView();
    }
  }

  void _closeStoryView() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.onBack();
    } else {
      Navigator.pop(context);
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _progressController.stop();
      } else {
        _progressController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // При открытии экрана помечаем первый сториз как просмотренный
    if (_currentIndex == 0) {
      _markCurrentStoryAsViewed();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => _togglePause(),
        onTapUp: (_) => _togglePause(),
        onLongPressStart: (_) => _togglePause(),
        onLongPressEnd: (_) => _togglePause(),
        child: Stack(
          children: [
            // Контент сториз
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _progressController.duration = widget.stories[index].duration;
                  _startProgressAnimation();
                });
              },
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return _StoryContent(story: story);
              },
            ),

            // Прогресс бар
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(widget.stories.length, (index) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          // Фон прогресса
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Активный прогресс
                          if (index == _currentIndex)
                            AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  widthFactor: _progressController.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Кнопка закрытия
            Positioned(
              top: 32,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  final navigationService = NavigationService.of(context);
                  if (navigationService != null) {
                    navigationService.onBack();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Навигационные жесты
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.3,
              child: GestureDetector(
                onTap: _goToPreviousStory,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.3,
              child: GestureDetector(
                onTap: _goToNextStory,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryContent extends StatelessWidget {
  final Story story;

  const _StoryContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: story.backgroundColor,
      child: Stack(
        children: [
          // Фоновое изображение
          Positioned.fill(
            child: Image.network(
              story.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: story.backgroundColor,
                  child: Icon(
                    _getStoryIcon(story.type),
                    color: Colors.white,
                    size: 64,
                  ),
                );
              },
            ),
          ),

          // Градиентный оверлей
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Контент
          Positioned(
            left: 20,
            right: 20,
            bottom: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: AppTextStyles.headline4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  story.description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  _formatDate(story.createdAt),
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStoryIcon(StoryType type) {
    switch (type) {
      case StoryType.news:
        return Icons.new_releases;
      case StoryType.promotion:
        return Icons.local_offer;
      case StoryType.event:
        return Icons.event;
      case StoryType.training:
        return Icons.fitness_center;
      case StoryType.achievement:
        return Icons.emoji_events;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}