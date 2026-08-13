import 'package:ubatku/models/medicine.dart';

class MockData {
  static final List<Medicine> medicines = [
    Medicine(
      id: '1',
      name: 'Paracetamol',
      dosage: '500mg',
      frequency: MedicineFrequency.twiceDaily,
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 9, 1),
      notes: 'For pain relief. Take with food.',
      reminderEnabled: true,
    ),
    Medicine(
      id: '2',
      name: 'Vitamin C',
      dosage: '1 tablet',
      frequency: MedicineFrequency.daily,
      startDate: DateTime(2026, 7, 15),
      notes: 'Daily immune support',
      reminderEnabled: true,
    ),
    Medicine(
      id: '3',
      name: 'Amoxicillin',
      dosage: '500mg',
      frequency: MedicineFrequency.threeTimesDaily,
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 20),
      notes: 'Antibiotic for infection. Complete full course.',
      reminderEnabled: true,
    ),
    Medicine(
      id: '4',
      name: 'Ibuprofen',
      dosage: '400mg',
      frequency: MedicineFrequency.twiceDaily,
      startDate: DateTime(2026, 8, 5),
      endDate: DateTime(2026, 8, 15),
      notes: 'For inflammation',
      reminderEnabled: true,
    ),
    Medicine(
      id: '5',
      name: 'Metformin',
      dosage: '500mg',
      frequency: MedicineFrequency.twiceDaily,
      startDate: DateTime(2026, 6, 1),
      notes: 'Blood sugar management',
      reminderEnabled: true,
    ),
  ];

  static List<MedicineReminder> getTodayReminders(List<Medicine> medicineList) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminders = <MedicineReminder>[];

    for (var medicine in medicineList) {
      if (medicine.reminderEnabled && medicine.isActive) {
        // Generate reminders based on frequency
        final times = _getScheduledTimes(medicine.frequency);
        for (int i = 0; i < times.length; i++) {
          final time = times[i];
          final scheduledDateTime = today.add(
            Duration(hours: time.hour, minutes: time.minute),
          );

          reminders.add(
            MedicineReminder(
              id: '${medicine.id}-$i',
              medicineId: medicine.id,
              scheduledTime: scheduledDateTime,
              status: _getStatusForTime(scheduledDateTime, medicine),
            ),
          );
        }
      }
    }

    // Sort by time
    reminders.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return reminders;
  }

  static List<DateTime> _getScheduledTimes(MedicineFrequency frequency) {
    switch (frequency) {
      case MedicineFrequency.daily:
        return [
          DateTime(0, 0, 0, 8, 0), // 8:00 AM
        ];
      case MedicineFrequency.twiceDaily:
        return [
          DateTime(0, 0, 0, 8, 0), // 8:00 AM
          DateTime(0, 0, 0, 20, 0), // 8:00 PM
        ];
      case MedicineFrequency.threeTimesDaily:
        return [
          DateTime(0, 0, 0, 8, 0), // 8:00 AM
          DateTime(0, 0, 0, 13, 0), // 1:00 PM
          DateTime(0, 0, 0, 20, 0), // 8:00 PM
        ];
      case MedicineFrequency.everyOtherDay:
        return [
          DateTime(0, 0, 0, 8, 0), // 8:00 AM
        ];
      case MedicineFrequency.weekly:
        return [
          DateTime(0, 0, 0, 8, 0), // 8:00 AM
        ];
    }
  }

  static MedicineStatus _getStatusForTime(
    DateTime scheduledTime,
    Medicine medicine,
  ) {
    final now = DateTime.now();

    // Simulated status based on time
    if (scheduledTime.isAfter(now)) {
      return MedicineStatus.upcoming;
    }

    // Simulate taken/skipped based on medicine id and hour
    final hour = scheduledTime.hour;
    if (medicine.id == '1' && hour == 8) {
      return MedicineStatus.taken;
    } else if (medicine.id == '1' && hour == 20) {
      return MedicineStatus.upcoming;
    } else if (medicine.id == '2' && hour == 8) {
      return MedicineStatus.taken;
    } else if (medicine.id == '3' && hour == 8) {
      return MedicineStatus.taken;
    } else if (medicine.id == '3' && hour == 13) {
      return MedicineStatus.skipped;
    } else if (medicine.id == '3' && hour == 20) {
      return MedicineStatus.upcoming;
    } else if (medicine.id == '4' && hour == 8) {
      return MedicineStatus.taken;
    } else if (medicine.id == '4' && hour == 20) {
      return MedicineStatus.taken;
    } else if (medicine.id == '5' && hour == 8) {
      return MedicineStatus.taken;
    } else if (medicine.id == '5' && hour == 20) {
      return MedicineStatus.upcoming;
    }

    return MedicineStatus.upcoming;
  }

  static List<MedicineIntake> getMedicationHistory() {
    final today = DateTime.now();

    return [
      // Today
      MedicineIntake(
        id: 'h1',
        medicineId: '1',
        medicineName: 'Paracetamol',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day, 8, 30),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h2',
        medicineId: '2',
        medicineName: 'Vitamin C',
        dosage: '1 tablet',
        dateTime: DateTime(today.year, today.month, today.day, 8, 45),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h3',
        medicineId: '3',
        medicineName: 'Amoxicillin',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day, 8, 15),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h4',
        medicineId: '3',
        medicineName: 'Amoxicillin',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day, 13, 0),
        status: MedicineStatus.skipped,
      ),
      MedicineIntake(
        id: 'h5',
        medicineId: '4',
        medicineName: 'Ibuprofen',
        dosage: '400mg',
        dateTime: DateTime(today.year, today.month, today.day, 8, 20),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h6',
        medicineId: '4',
        medicineName: 'Ibuprofen',
        dosage: '400mg',
        dateTime: DateTime(today.year, today.month, today.day, 20, 15),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h7',
        medicineId: '5',
        medicineName: 'Metformin',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day, 8, 0),
        status: MedicineStatus.taken,
      ),

      // Yesterday
      MedicineIntake(
        id: 'h8',
        medicineId: '1',
        medicineName: 'Paracetamol',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 1, 8, 30),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h9',
        medicineId: '1',
        medicineName: 'Paracetamol',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 1, 20, 15),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h10',
        medicineId: '2',
        medicineName: 'Vitamin C',
        dosage: '1 tablet',
        dateTime: DateTime(today.year, today.month, today.day - 1, 8, 45),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h11',
        medicineId: '3',
        medicineName: 'Amoxicillin',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 1, 8, 15),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h12',
        medicineId: '3',
        medicineName: 'Amoxicillin',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 1, 13, 30),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h13',
        medicineId: '3',
        medicineName: 'Amoxicillin',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 1, 20, 0),
        status: MedicineStatus.taken,
      ),

      // 2 days ago
      MedicineIntake(
        id: 'h14',
        medicineId: '1',
        medicineName: 'Paracetamol',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 2, 8, 30),
        status: MedicineStatus.taken,
      ),
      MedicineIntake(
        id: 'h15',
        medicineId: '1',
        medicineName: 'Paracetamol',
        dosage: '500mg',
        dateTime: DateTime(today.year, today.month, today.day - 2, 20, 0),
        status: MedicineStatus.skipped,
      ),
      MedicineIntake(
        id: 'h16',
        medicineId: '2',
        medicineName: 'Vitamin C',
        dosage: '1 tablet',
        dateTime: DateTime(today.year, today.month, today.day - 2, 8, 45),
        status: MedicineStatus.taken,
      ),
    ];
  }
}
