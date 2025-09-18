import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import 'employee_welcome_section.dart';
import 'employee_schedule_section.dart';
import 'employee_quick_actions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../clietnt/home_section_widget.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final Function(String, [dynamic]) onQuickAccessNavigate;

  const EmployeeHomeScreen({super.key, required this.onQuickAccessNavigate});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool _showSchedule = true;

  @override
  Widget build(BuildContext context) {
    final allTrainings = MockDataService.employeeTrainings;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Приветствие сотрудника
            EmployeeWelcomeSection(
              user: MockDataService.currentUser,
              onQuickAccessNavigate: widget.onQuickAccessNavigate,
            ),
            const SizedBox(height: 16),

            // Быстрые команды
            HomeSectionWidget(
              title: 'Быстрые команды',
              isExpanded: _showSchedule,
              onToggle: () => setState(() => _showSchedule = !_showSchedule),
              child: EmployeeQuickActions(
                onQuickAccessNavigate: widget.onQuickAccessNavigate,
              ),
            ),
            const SizedBox(height: 16),

            // Расписание тренировок
            HomeSectionWidget(
              title: 'Мое расписание',
              isExpanded: _showSchedule,
              onToggle: () => setState(() => _showSchedule = !_showSchedule),
              child: EmployeeScheduleSection(
                allTrainings: allTrainings,
                onTrainingTap: _navigateToTrainingDetail,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToTrainingDetail(Booking training) {
    widget.onQuickAccessNavigate('training_detail', training);
  }
}