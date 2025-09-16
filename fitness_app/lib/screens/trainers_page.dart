import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/page_header.dart';
import 'package:fitness_app/widgets/card.dart';
import 'package:fitness_app/widgets/button.dart';
import 'package:fitness_app/widgets/list_item.dart';

class TrainersPage extends StatelessWidget {
  final List<Map<String, dynamic>> trainers;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final Function(Map<String, dynamic>) openTrainerProfile;
  final Function() showNotificationMessage;

  const TrainersPage({
    super.key,
    required this.trainers,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.openTrainerProfile,
    required this.showNotificationMessage,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTrainers = trainers.where((trainer) =>
      trainer['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
      trainer['specialty'].toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          PageHeader(
            title: 'Наши тренеры',
            subtitle: 'Выберите специалиста',
          ),
          
          const SizedBox(height: 12),
          
          TextField(
            decoration: InputDecoration(
              hintText: 'Поиск тренера...',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: onSearchChanged,
          ),
          
          const SizedBox(height: 12),
          
          CardWidget(
            header: 'Популярные тренеры',
            badge: '6',
            child: Column(
              children: trainers.take(3).map((trainer) => ListItem(
                avatar: trainer['avatar'],
                title: trainer['name'],
                subtitle: '${trainer['specialty']} • ${trainer['rating']} ★',
                meta: Button(
                  variant: 'success',
                  label: 'Чат',
                  onPressed: () => openTrainerProfile(trainer),
                  small: true,
                ),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          CardWidget(
            header: 'Все тренеры',
            badge: filteredTrainers.length.toString(),
            child: Column(
              children: filteredTrainers.map((trainer) => ListItem(
                avatar: trainer['avatar'],
                title: trainer['name'],
                subtitle: '${trainer['specialty']} • ${trainer['rating']} ★',
                meta: Button(
                  variant: 'secondary',
                  label: 'Профиль',
                  onPressed: () => openTrainerProfile(trainer),
                  small: true,
                ),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Button(
            variant: 'primary',
            label: 'Расширенный поиск',
            icon: Icons.search,
            onPressed: () => showNotificationMessage(),
          ),
        ],
      ),
    );
  }
}