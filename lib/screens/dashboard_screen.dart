import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/data/mock_data.dart';
import 'package:ubatku/widgets/medicine_card.dart';
import 'package:ubatku/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Medicine> medicines;
  late List<MedicineReminder> todayReminders;

  @override
  void initState() {
    super.initState();
    medicines = MockData.medicines;
    todayReminders = MockData.getTodayReminders(medicines);
  }

  void _updateReminderStatus(int index, MedicineStatus status) {
    setState(() {
      todayReminders[index] = todayReminders[index].copyWith(status: status);
    });
  }

  String get _todayDate {
    final now = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  int get _takenCount {
    return todayReminders.where((r) => r.status == MedicineStatus.taken).length;
  }

  int get _skippedCount {
    return todayReminders
        .where((r) => r.status == MedicineStatus.skipped)
        .length;
  }

  int get _upcomingCount {
    return todayReminders
        .where((r) => r.status == MedicineStatus.upcoming)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UbatKu'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              color: UbatKuTheme.primary,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _todayDate,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Status Cards
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      context,
                      'Taken',
                      _takenCount.toString(),
                      UbatKuTheme.secondary,
                      Icons.check_circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusCard(
                      context,
                      'Upcoming',
                      _upcomingCount.toString(),
                      UbatKuTheme.tertiary,
                      Icons.schedule,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusCard(
                      context,
                      'Skipped',
                      _skippedCount.toString(),
                      UbatKuTheme.error,
                      Icons.cancel,
                    ),
                  ),
                ],
              ),
            ),

            // Today's Medicines Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Today's Medicines",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            // Medicines List
            if (todayReminders.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Center(
                  child: Text(
                    'No medicines scheduled for today',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ...todayReminders.asMap().entries.map((entry) {
                final index = entry.key;
                final reminder = entry.value;
                final medicine = medicines.firstWhere(
                  (m) => m.id == reminder.medicineId,
                );

                return MedicineCard(
                  reminder: reminder,
                  medicine: medicine,
                  onStatusChanged: (status) {
                    _updateReminderStatus(index, status);
                  },
                );
              }),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    String label,
    String count,
    Color color,
    IconData icon,
  ) {
    return Card(
      color: color.withAlpha((0.1 * 255).toInt()),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              count,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
