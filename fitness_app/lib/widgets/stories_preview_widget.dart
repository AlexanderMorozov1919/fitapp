import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/story_model.dart';
import '../services/mock_data/story_data.dart';
import '../services/story_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StoriesPreviewWidget extends StatelessWidget {
  final Function(String) onStoryTap;
  final double height;
  final double itemWidth;

  const StoriesPreviewWidget({
    super.key,
    required this.onStoryTap,
    this.height = 90,
    this.itemWidth = 70,
  });

  @override
  Widget build(BuildContext context) {
    final stories = StoryData.getActiveStories();
    final storyService = Provider.of<StoryService>(context, listen: true);

    if (stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final isViewed = storyService.isStoryViewed(story.id);
                
                return _StoryPreviewItem(
                  story: story,
                  width: itemWidth,
                  isViewed: isViewed,
                  onTap: () => onStoryTap(story.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryPreviewItem extends StatelessWidget {
  final Story story;
  final double width;
  final bool isViewed;
  final VoidCallback onTap;

  const _StoryPreviewItem({
    required this.story,
    required this.width,
    required this.isViewed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Аватар сториз с градиентной обводкой и индикатором просмотра
            Stack(
              children: [
                Container(
                  width: width - 16,
                  height: width - 16,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        story.backgroundColor,
                        story.backgroundColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12), // Закругленные углы
                    border: Border.all(
                      color: isViewed ? Colors.grey : AppColors.primary,
                      width: isViewed ? 1 : 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Закругленные углы для изображения
                    child: Image.network(
                      story.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: story.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getStoryIcon(story.type),
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Индикатор нового сториз
                if (!isViewed)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
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

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}