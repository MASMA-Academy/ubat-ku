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
      version: 2,
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
            reminder_enabled INTEGER NOT NULL DEFAULT 1,
            reminder_hour INTEGER NOT NULL DEFAULT 8,
            reminder_minute INTEGER NOT NULL DEFAULT 0
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE medicines ADD COLUMN reminder_hour INTEGER NOT NULL DEFAULT 8',
          );
          await db.execute(
            'ALTER TABLE medicines ADD COLUMN reminder_minute INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
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

      final times = _scheduledTimesFor(
        medicine.frequency,
        medicine.reminderHour,
        medicine.reminderMinute,
      );
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

  /// Builds today's dose offsets anchored on the medicine's chosen reminder
  /// time, spacing any additional daily doses evenly across 24 hours.
  List<Duration> _scheduledTimesFor(
    MedicineFrequency frequency,
    int reminderHour,
    int reminderMinute,
  ) {
    final baseMinutes = reminderHour * 60 + reminderMinute;
    final dosesPerDay = frequency.timesPerDay;
    final spacingMinutes = (24 * 60) ~/ dosesPerDay;

    return List.generate(dosesPerDay, (i) {
      final minutes = (baseMinutes + i * spacingMinutes) % (24 * 60);
      return Duration(minutes: minutes);
    });
  }

}
