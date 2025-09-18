import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../main.dart';

class HomeWelcomeSection extends StatelessWidget {
  final User user;

  final Function(String, [dynamic]) onQuickAccessNavigate;

  const HomeWelcomeSection({
    super.key,
    required this.user,
    required this.onQuickAccessNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: AppStyles.primaryCardDecoration,
      child: Row(
        children: [
          // Аватар с градиентным фоном
          _buildAvatar(),
          const SizedBox(width: 16),
          
          // Информация о пользователе
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  user.firstName,
                  style: AppTextStyles.headline4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (user.membership != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: AppStyles.borderRadiusSm,
                    ),
                    child: Text(
                      user.membership!.type,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Кнопка чата вместо баланса
          _buildChatButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9A8B), Color(0xFFFF6B6B)],
        ),
        borderRadius: AppStyles.borderRadiusFull,
        boxShadow: AppColors.shadowLg,
      ),
      child: user.photoUrl != null
          ? ClipRRect(
              borderRadius: AppStyles.borderRadiusFull,
              child: Image.network(
                user.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Icon(
        Icons.person,
        size: 28,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Widget _buildChatButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onQuickAccessNavigate('chat'),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 1.0, end: 1.1),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1000),
                tween: ColorTween(
                  begin: Colors.white.withOpacity(0.15),
                  end: const Color(0xFF4FC3F7).withOpacity(0.15),
                ),
                builder: (context, color, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppStyles.borderRadiusLg,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Чат',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}