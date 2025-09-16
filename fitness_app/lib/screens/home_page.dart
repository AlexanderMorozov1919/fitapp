import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/page_header.dart';
import 'package:fitness_app/widgets/profile_header.dart';
import 'package:fitness_app/widgets/card.dart';
import 'package:fitness_app/widgets/button.dart';
import 'package:fitness_app/widgets/list_item.dart';
import 'package:fitness_app/widgets/stat_card.dart';
import 'package:fitness_app/widgets/quick_action.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final Function(String) openBookingForm;
  final Function() showNotificationMessage;
  final Function(String) onPageChanged;

  const HomePage({
    super.key,
    required this.events,
    required this.openBookingForm,
    required this.showNotificationMessage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          PageHeader(
            title: 'Добро пожаловать!',
            subtitle: 'FitnessPro Client',
          ),
          const SizedBox(height: 12),
          
          ProfileHeader(
            name: 'Александр Козлов',
            status: 'Премиум абонемент до 15.12.2023',
            visits: '12',
            goal: '85',
            days: '42',
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            height: 100, // Фиксированная высота для быстрых действий
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.8,
              children: [
                QuickAction(
                  icon: Icons.calendar_today,
                  label: 'Расписание',
                  onTap: () => onPageChanged('schedule'),
                ),
                QuickAction(
                  icon: Icons.people,
                  label: 'Тренеры',
                  onTap: () => onPageChanged('trainers'),
                ),
                QuickAction(
                  icon: Icons.check_circle,
                  label: 'Прогресс',
                  onTap: () => onPageChanged('progress'),
                ),
                QuickAction(
                  icon: Icons.shopping_cart,
                  label: 'Магазин',
                  onTap: () => onPageChanged('shop'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          SizedBox(
            height: 120, // Фиксированная высота для статистических карточек
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                StatCard(value: '3', label: 'Занятия сегодня'),
                StatCard(value: '15', label: 'Осталось посещений', color: 'green'),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          CardWidget(
            header: 'Ближайшие занятия',
            badge: 'Сегодня',
            child: Column(
              children: events.take(3).map((event) => ListItem(
                avatar: (event['trainer'] as String).split(' ')[0][0],
                title: event['title'],
                subtitle: '${event['location']} • ${event['time']}',
                meta: Button(
                  variant: 'success',
                  label: 'Записаться',
                  onPressed: () => openBookingForm(event['id'].toString()),
                  small: true,
                ),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Button(
            variant: 'primary',
            label: 'Установить напоминание',
            icon: Icons.notifications,
            onPressed: () => showNotificationMessage(),
          ),
        ],
      ),
    );
  }
}