enum MedicineFrequency {
  daily,
  twiceDaily,
  threeTimesDaily,
  everyOtherDay,
  weekly,
}

extension FrequencyDisplay on MedicineFrequency {
  String get displayName {
    switch (this) {
      case MedicineFrequency.daily:
        return 'Daily';
      case MedicineFrequency.twiceDaily:
        return 'Twice Daily';
      case MedicineFrequency.threeTimesDaily:
        return 'Three Times Daily';
      case MedicineFrequency.everyOtherDay:
        return 'Every Other Day';
      case MedicineFrequency.weekly:
        return 'Weekly';
    }
  }

  int get timesPerDay {
    switch (this) {
      case MedicineFrequency.daily:
        return 1;
      case MedicineFrequency.twiceDaily:
        return 2;
      case MedicineFrequency.threeTimesDaily:
        return 3;
      case MedicineFrequency.everyOtherDay:
        return 1;
      case MedicineFrequency.weekly:
        return 1;
    }
  }
}

enum MedicineStatus { upcoming, taken, skipped, missed }

extension StatusDisplay on MedicineStatus {
  String get displayName {
    switch (this) {
      case MedicineStatus.upcoming:
        return 'Upcoming';
      case MedicineStatus.taken:
        return 'Taken';
      case MedicineStatus.skipped:
        return 'Skipped';
      case MedicineStatus.missed:
        return 'Missed';
    }
  }
}

class Medicine {
  final String id;
  final String name;
  final String dosage;
  final MedicineFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool reminderEnabled;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.notes,
    this.reminderEnabled = true,
  });

  bool get isActive {
    if (endDate == null) return true;
    return DateTime.now().isBefore(endDate!);
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? dosage,
    MedicineFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? reminderEnabled,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }
}

class MedicineReminder {
  final String id;
  final String medicineId;
  final DateTime scheduledTime;
  final MedicineStatus status;

  MedicineReminder({
    required this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.status = MedicineStatus.upcoming,
  });

  bool get isPast => DateTime.now().isAfter(scheduledTime);

  MedicineReminder copyWith({
    String? id,
    String? medicineId,
    DateTime? scheduledTime,
    MedicineStatus? status,
  }) {
    return MedicineReminder(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
    );
  }
}

class MedicineIntake {
  final String id;
  final String medicineId;
  final String medicineName;
  final String dosage;
  final DateTime dateTime;
  final MedicineStatus status;

  MedicineIntake({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.dateTime,
    this.status = MedicineStatus.taken,
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final intakeDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (intakeDay == today) {
      return 'Today';
    } else if (intakeDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${intakeDay.day} ${_monthName(intakeDay.month)} ${intakeDay.year}';
    }
  }

  String _monthName(int month) {
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
    return months[month - 1];
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
