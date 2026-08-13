import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ubatku/models/medicine.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ubatku.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE medicines (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            frequency TEXT NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT,
            notes TEXT,
            reminder_enabled INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute('''
          CREATE TABLE medicine_intakes (
            id TEXT PRIMARY KEY,
            medicine_id TEXT NOT NULL,
            medicine_name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            date_time TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
        await _seedInitialData(db);
      },
    );
  }

  Future<void> _seedInitialData(Database db) async {
    final batch = db.batch();

    for (final medicine in _seedMedicines) {
      batch.insert('medicines', medicine.toMap());
    }
    for (final intake in _seedIntakes) {
      batch.insert('medicine_intakes', intake.toMap());
    }

    await batch.commit(noResult: true);
  }

  // ---- Medicines ----

  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    final rows = await db.query('medicines', orderBy: 'name ASC');
    return rows.map(Medicine.fromMap).toList();
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert(
      'medicines',
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;
    await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> deleteMedicine(String id) async {
    final db = await database;
    await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
    await db.delete(
      'medicine_intakes',
      where: 'medicine_id = ?',
      whereArgs: [id],
    );
  }

  // ---- Intakes / History ----

  Future<List<MedicineIntake>> getMedicationHistory() async {
    final db = await database;
    final rows = await db.query('medicine_intakes', orderBy: 'date_time DESC');
    return rows.map(MedicineIntake.fromMap).toList();
  }

  /// Records (or overwrites) the outcome of a scheduled dose slot.
  Future<void> setReminderStatus({
    required Medicine medicine,
    required DateTime scheduledTime,
    required MedicineStatus status,
  }) async {
    final db = await database;
    final intake = MedicineIntake(
      id: '${medicine.id}_${scheduledTime.toIso8601String()}',
      medicineId: medicine.id,
      medicineName: medicine.name,
      dosage: medicine.dosage,
      dateTime: scheduledTime,
      status: status,
    );
    await db.insert(
      'medicine_intakes',
      intake.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---- Today's reminders (computed from schedule + logged intakes) ----

  Future<List<MedicineReminder>> getTodayReminders() async {
    final medicines = await getMedicines();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayEnd = today.add(Duration(days: 1));

    final db = await database;
    final todaysIntakeRows = await db.query(
      'medicine_intakes',
      where: 'date_time >= ? AND date_time < ?',
      whereArgs: [today.toIso8601String(), todayEnd.toIso8601String()],
    );
    final todaysIntakes = todaysIntakeRows.map(MedicineIntake.fromMap).toList();

    final reminders = <MedicineReminder>[];

    for (final medicine in medicines) {
      if (!medicine.reminderEnabled || !medicine.isActive) continue;

      final times = _scheduledTimesFor(medicine.frequency);
      for (var i = 0; i < times.length; i++) {
        final scheduledDateTime = today.add(times[i]);
        final match = todaysIntakes.where(
          (intake) =>
              intake.medicineId == medicine.id &&
              intake.dateTime.hour == scheduledDateTime.hour,
        );

        final MedicineStatus status;
        if (match.isNotEmpty) {
          status = match.first.status;
        } else if (scheduledDateTime.isBefore(now)) {
          status = MedicineStatus.missed;
        } else {
          status = MedicineStatus.upcoming;
        }

        reminders.add(
          MedicineReminder(
            id: '${medicine.id}-$i',
            medicineId: medicine.id,
            scheduledTime: scheduledDateTime,
            status: status,
          ),
        );
      }
    }

    reminders.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return reminders;
  }

  List<Duration> _scheduledTimesFor(MedicineFrequency frequency) {
    switch (frequency) {
      case MedicineFrequency.daily:
      case MedicineFrequency.everyOtherDay:
      case MedicineFrequency.weekly:
        return [Duration(hours: 8)];
      case MedicineFrequency.twiceDaily:
        return [Duration(hours: 8), Duration(hours: 20)];
      case MedicineFrequency.threeTimesDaily:
        return [Duration(hours: 8), Duration(hours: 13), Duration(hours: 20)];
    }
  }

  // ---- Seed data (first run only) ----

  static final List<Medicine> _seedMedicines = [
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

  static List<MedicineIntake> get _seedIntakes {
    final today = DateTime.now();

    DateTime on(int daysAgo, int hour, int minute) {
      final d = today.subtract(Duration(days: daysAgo));
      return DateTime(d.year, d.month, d.day, hour, minute);
    }

    final entries = <(String, String, String, String, DateTime, MedicineStatus)>[
      ('h1', '1', 'Paracetamol', '500mg', on(0, 8, 30), MedicineStatus.taken),
      ('h2', '2', 'Vitamin C', '1 tablet', on(0, 8, 45), MedicineStatus.taken),
      ('h3', '3', 'Amoxicillin', '500mg', on(0, 8, 15), MedicineStatus.taken),
      ('h4', '3', 'Amoxicillin', '500mg', on(0, 13, 0), MedicineStatus.skipped),
      ('h5', '4', 'Ibuprofen', '400mg', on(0, 8, 20), MedicineStatus.taken),
      ('h6', '5', 'Metformin', '500mg', on(0, 8, 0), MedicineStatus.taken),
      ('h7', '1', 'Paracetamol', '500mg', on(1, 8, 30), MedicineStatus.taken),
      ('h8', '1', 'Paracetamol', '500mg', on(1, 20, 15), MedicineStatus.taken),
      ('h9', '2', 'Vitamin C', '1 tablet', on(1, 8, 45), MedicineStatus.taken),
      ('h10', '3', 'Amoxicillin', '500mg', on(1, 8, 15), MedicineStatus.taken),
      ('h11', '3', 'Amoxicillin', '500mg', on(1, 13, 30), MedicineStatus.taken),
      ('h12', '3', 'Amoxicillin', '500mg', on(1, 20, 0), MedicineStatus.taken),
      ('h13', '1', 'Paracetamol', '500mg', on(2, 8, 30), MedicineStatus.taken),
      ('h14', '1', 'Paracetamol', '500mg', on(2, 20, 0), MedicineStatus.skipped),
      ('h15', '2', 'Vitamin C', '1 tablet', on(2, 8, 45), MedicineStatus.taken),
    ];

    return entries
        .map(
          (e) => MedicineIntake(
            id: e.$1,
            medicineId: e.$2,
            medicineName: e.$3,
            dosage: e.$4,
            dateTime: e.$5,
            status: e.$6,
          ),
        )
        .toList();
  }
}
