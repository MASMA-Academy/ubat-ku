import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/data/database_helper.dart';
import 'package:ubatku/screens/add_edit_medicine_screen.dart';
import 'package:ubatku/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = DatabaseHelper.instance;
  List<Medicine> medicines = [];
  List<MedicineReminder> todayReminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedMedicines = await _db.getMedicines();
    final loadedReminders = await _db.getTodayReminders();
    if (!mounted) return;
    setState(() {
      medicines = loadedMedicines;
      todayReminders = loadedReminders;
      _isLoading = false;
    });
  }

  Future<void> _updateReminderStatus(
    Medicine medicine,
    DateTime scheduledTime,
    MedicineStatus status,
  ) async {
    await _db.setReminderStatus(
      medicine: medicine,
      scheduledTime: scheduledTime,
      status: status,
    );
    await _loadData();
  }

  Future<void> _addMedicine(Medicine medicine) async {
    await _db.insertMedicine(medicine);
    await _loadData();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  int get _takenCount {
    return todayReminders.where((r) => r.status == MedicineStatus.taken).length;
  }

  int get _nextDoseIndex {
    return todayReminders.indexWhere(
      (r) => r.status == MedicineStatus.upcoming,
    );
  }

  String _timeOfDayLabel(DateTime time) {
    if (time.hour < 12) return 'Morning';
    if (time.hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String _formattedTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: UbatKuTheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: UbatKuTheme.primary),
        ),
      );
    }

    final total = todayReminders.length;
    final adherence = total == 0 ? 0.0 : _takenCount / total;
    final nextDoseIndex = _nextDoseIndex;

    return Scaffold(
      backgroundColor: UbatKuTheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UbatKuTheme.surface,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: UbatKuTheme.primaryContainer.withAlpha(
                  (0.25 * 255).toInt(),
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medication,
                color: UbatKuTheme.primary,
                size: 22,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'UbatKu',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: UbatKuTheme.primary,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: UbatKuTheme.onSurfaceVariant),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Today's Schedule",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              total == 0
                  ? 'No medicines scheduled for today.'
                  : 'You are doing great! $_takenCount of $total taken.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: UbatKuTheme.onSurfaceVariant),
            ),
            SizedBox(height: 24),

            // Adherence Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.7 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha((0.5 * 255).toInt())),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).toInt()),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Adherence',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: UbatKuTheme.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Keep it up!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: UbatKuTheme.outline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: adherence,
                            strokeWidth: 4,
                            backgroundColor: UbatKuTheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              UbatKuTheme.secondaryFixed,
                            ),
                          ),
                        ),
                        Text(
                          '${(adherence * 100).round()}%',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: UbatKuTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Medication Cards
            if (todayReminders.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
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
                final isNextDose = index == nextDoseIndex;

                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _MedicationCard(
                    medicine: medicine,
                    reminder: reminder,
                    isNextDose: isNextDose,
                    badgeLabel: isNextDose
                        ? 'Next Dose'
                        : _timeOfDayLabel(reminder.scheduledTime),
                    timeLabel: _formattedTime(reminder.scheduledTime),
                    onMarkTaken: () => _updateReminderStatus(
                      medicine,
                      reminder.scheduledTime,
                      MedicineStatus.taken,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditMedicineScreen(onSave: _addMedicine),
            ),
          );
        },
        backgroundColor: UbatKuTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medicine medicine;
  final MedicineReminder reminder;
  final bool isNextDose;
  final String badgeLabel;
  final String timeLabel;
  final VoidCallback onMarkTaken;

  const _MedicationCard({
    required this.medicine,
    required this.reminder,
    required this.isNextDose,
    required this.badgeLabel,
    required this.timeLabel,
    required this.onMarkTaken,
  });

  Color get _accentColor {
    if (isNextDose) return UbatKuTheme.primary;
    switch (reminder.status) {
      case MedicineStatus.taken:
        return UbatKuTheme.secondaryFixedDim;
      case MedicineStatus.skipped:
      case MedicineStatus.missed:
        return UbatKuTheme.error;
      case MedicineStatus.upcoming:
        return UbatKuTheme.outlineVariant;
    }
  }

  Color get _badgeBackground {
    if (isNextDose) return UbatKuTheme.primaryContainer;
    switch (reminder.status) {
      case MedicineStatus.taken:
        return UbatKuTheme.surfaceContainerHigh;
      case MedicineStatus.skipped:
      case MedicineStatus.missed:
        return UbatKuTheme.errorContainer;
      case MedicineStatus.upcoming:
        return UbatKuTheme.surfaceContainer;
    }
  }

  Color get _badgeTextColor {
    if (isNextDose) return UbatKuTheme.onPrimaryContainer;
    switch (reminder.status) {
      case MedicineStatus.skipped:
      case MedicineStatus.missed:
        return UbatKuTheme.error;
      default:
        return UbatKuTheme.onSurfaceVariant;
    }
  }

  Widget _buildTrailing(BuildContext context) {
    switch (reminder.status) {
      case MedicineStatus.taken:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: UbatKuTheme.primary.withAlpha((0.1 * 255).toInt()),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: UbatKuTheme.primary),
        );
      case MedicineStatus.skipped:
      case MedicineStatus.missed:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: UbatKuTheme.error.withAlpha((0.1 * 255).toInt()),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.cancel, color: UbatKuTheme.error),
        );
      case MedicineStatus.upcoming:
        return SizedBox(
          width: 48,
          height: 48,
          child: OutlinedButton(
            onPressed: onMarkTaken,
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.zero,
              side: BorderSide(color: UbatKuTheme.outlineVariant, width: 2),
            ),
            child: Icon(
              Icons.radio_button_unchecked,
              color: UbatKuTheme.outlineVariant,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTaken = reminder.status == MedicineStatus.taken;

    return Container(
      decoration: BoxDecoration(
        color: UbatKuTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _accentColor, width: 8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(((isNextDose ? 0.08 : 0.05) * 255).toInt()),
            blurRadius: isNextDose ? 30 : 20,
            offset: Offset(0, isNextDose ? 8 : 4),
          ),
        ],
      ),
      constraints: BoxConstraints(minHeight: 80),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _badgeBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _badgeTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  medicine.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    decoration: isTaken ? TextDecoration.lineThrough : null,
                    color: isTaken
                        ? UbatKuTheme.onSurface.withAlpha((0.7 * 255).toInt())
                        : UbatKuTheme.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${medicine.dosage} • $timeLabel',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: UbatKuTheme.outline),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          _buildTrailing(context),
        ],
      ),
    );
  }
}
