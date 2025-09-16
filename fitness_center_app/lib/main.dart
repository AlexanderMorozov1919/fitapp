import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/screens/home_screen.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/navigation/route_generator.dart';

void main() {
  runApp(const FitnessCenterApp());
}

class FitnessCenterApp extends StatelessWidget {
  const FitnessCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Center Pro',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      initialRoute: AppRoutes.home,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const HomeScreen(),
    );
  }
}

class AppContainer extends StatelessWidget {
  final Widget child;
  final bool showNotch;
  final bool showStatusBar;
  final bool showBottomNav;

  const AppContainer({
    super.key,
    required this.child,
    this.showNotch = true,
    this.showStatusBar = true,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF667EEA),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.black, width: 12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(0, 25),
              ),
            ],
          ),
          child: Column(
            children: [
              if (showNotch) const _Notch(),
              if (showStatusBar) const _StatusBar(),
              Expanded(child: child),
              if (showBottomNav) const _BottomNavigation(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Row(
            children: const [
              Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.white),
              SizedBox(width: 5),
              Icon(Icons.wifi, size: 14, color: Colors.white),
              SizedBox(width: 5),
              Icon(Icons.battery_full, size: 14, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home, label: 'Главная', isActive: true),
          _NavItem(icon: Icons.calendar_today, label: 'Записаться'),
          _NavItem(icon: Icons.fitness_center, label: 'Тренеры'),
          _NavItem(icon: Icons.person, label: 'Профиль'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? AppTheme.primary : AppTheme.gray,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppTheme.primary : AppTheme.gray,
          ),
        ),
      ],
    );
  }
}
