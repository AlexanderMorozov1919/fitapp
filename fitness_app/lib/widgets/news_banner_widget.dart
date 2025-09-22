import 'dart:async';
import 'package:flutter/material.dart';
import '../services/mock_data/news_banner_data.dart';
import '../models/news_banner_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../main.dart';

class NewsBannerWidget extends StatefulWidget {
  final Function(String, [dynamic])? onBannerTap;

  const NewsBannerWidget({super.key, this.onBannerTap});

  @override
  State<NewsBannerWidget> createState() => _NewsBannerWidgetState();
}

class _NewsBannerWidgetState extends State<NewsBannerWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % NewsBannerData.banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onBannerTap(NewsBanner banner) {
    if (banner.actionRoute != null && widget.onBannerTap != null) {
      widget.onBannerTap!(banner.actionRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем, находимся ли мы в режиме личного кабинета
    final bool isPersonalCabinet = DeviceUtils.isPersonalCabinetMode();
    
    return Column(
      children: [

        // Карусель баннеров
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: NewsBannerData.banners.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final banner = NewsBannerData.banners[index];
              return Padding(
                padding: isPersonalCabinet
                    ? const EdgeInsets.all(16)
                    : const EdgeInsets.symmetric(horizontal: 16),
                child: _buildBannerCard(banner),
              );
            },
          ),
        ),

        // Индикаторы страниц
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            NewsBannerData.banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBannerCard(NewsBanner banner) {
    final bool isPersonalCabinet = DeviceUtils.isPersonalCabinetMode();
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onBannerTap(banner),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: banner.backgroundColor,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowMd,
          ),
          child: Padding(
            padding: AppStyles.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Text(
                  banner.title,
                  style: AppTextStyles.headline6.copyWith(
                    color: banner.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Описание
                Expanded(
                  child: Text(
                    banner.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: banner.textColor.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Кнопка действия
                if (banner.actionText != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: banner.textColor.withOpacity(0.2),
                        borderRadius: AppStyles.borderRadiusMd,
                        border: Border.all(
                          color: banner.textColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        banner.actionText!,
                        style: AppTextStyles.caption.copyWith(
                          color: banner.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}