import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/utils/animations.dart';

class LockerScreen extends StatefulWidget {
  const LockerScreen({super.key});

  @override
  State<LockerScreen> createState() => _LockerScreenState();
}

class _LockerScreenState extends State<LockerScreen> with SingleTickerProviderStateMixin {
  int? _selectedLocker;
  bool _lockerRented = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Шкафчики'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Locker Status
            FadeTransition(
              opacity: _fadeAnimation,
              child: _CurrentLockerStatus(
                isRented: _lockerRented,
                lockerNumber: _selectedLocker,
                onEndRental: () {
                  setState(() {
                    _lockerRented = false;
                    _selectedLocker = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 25),

            // Available Lockers
            const Text(
              'Доступные шкафчики',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 15),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: List.generate(24, (index) {
                  final lockerNumber = index + 1;
                  final isAvailable = lockerNumber % 3 != 0; // Some lockers are occupied
                  final isSelected = _selectedLocker == lockerNumber;
                  
                  return _LockerItem(
                    number: lockerNumber,
                    isAvailable: isAvailable,
                    isSelected: isSelected,
                    onTap: () {
                      if (isAvailable) {
                        setState(() => _selectedLocker = lockerNumber);
                      }
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 25),

            // Legend
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(
                    color: AppTheme.success,
                    label: 'Свободен',
                  ),
                  SizedBox(width: 20),
                  _LegendItem(
                    color: AppTheme.error,
                    label: 'Занят',
                  ),
                  SizedBox(width: 20),
                  _LegendItem(
                    color: AppTheme.primary,
                    label: 'Выбран',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Rent Button
            if (_selectedLocker != null && !_lockerRented)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _lockerRented = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Арендовать шкафчик',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CurrentLockerStatus extends StatelessWidget {
  final bool isRented;
  final int? lockerNumber;
  final VoidCallback onEndRental;

  const _CurrentLockerStatus({
    required this.isRented,
    this.lockerNumber,
    required this.onEndRental,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isRented ? AppTheme.success.withAlpha(30) : AppTheme.light,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  isRented ? Icons.lock_open : Icons.lock,
                  color: isRented ? AppTheme.success : AppTheme.gray,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRented ? 'Шкафчик арендован' : 'Шкафчик не арендован',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: isRented ? AppTheme.success : AppTheme.dark,
                      ),
                    ),
                    if (isRented && lockerNumber != null)
                      Text(
                        'Номер $lockerNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.gray,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (isRented) ...[
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: AppTheme.gray),
                const SizedBox(width: 8),
                const Text(
                  'Действует до: 23:59',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onEndRental,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Освободить'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LockerItem extends StatelessWidget {
  final int number;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback onTap;

  const _LockerItem({
    required this.number,
    required this.isAvailable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (isSelected) return AppTheme.primary;
      if (!isAvailable) return AppTheme.error;
      return AppTheme.success;
    }

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: getColor().withAlpha(isAvailable ? 30 : 15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: getColor(),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isAvailable ? Icons.lock_open : Icons.lock,
                color: getColor(),
                size: 24,
              ),
              const SizedBox(height: 5),
              Text(
                number.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: getColor(),
                ),
              ),
              if (!isAvailable)
                const Text(
                  'Занят',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.error,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.gray,
          ),
        ),
      ],
    );
  }
}