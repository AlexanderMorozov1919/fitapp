import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/page_header.dart';
import 'package:fitness_app/widgets/button.dart';
import 'package:fitness_app/widgets/calendar_event.dart';

class SchedulePage extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final Function(String) openBookingForm;
  final Function() showNotificationMessage;

  const SchedulePage({
    super.key,
    required this.events,
    required this.openBookingForm,
    required this.showNotificationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          PageHeader(
            title: 'Расписание занятий',
            subtitle: 'Выберите удобное время',
          ),
          
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[500]!, Colors.blue[400]!],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Сегодня, 15 ноября',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Среда',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 320,
                  child: ListView(
                    children: events.map((event) => CalendarEvent(
                      title: event['title'],
                      time: event['time'],
                      location: event['location'],
                      trainer: event['trainer'],
                      color: event['color'],
                      onTap: () => openBookingForm(event['id'].toString()),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          Button(
            variant: 'primary',
            label: 'Фильтровать по интересам',
            icon: Icons.filter_list,
            onPressed: () => showNotificationMessage(),
          ),
        ],
      ),
    );
  }
}