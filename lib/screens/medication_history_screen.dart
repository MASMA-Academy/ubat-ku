import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/data/mock_data.dart';
import 'package:ubatku/widgets/medicine_card.dart';
import 'package:ubatku/theme/app_theme.dart';

class MedicationHistoryScreen extends StatefulWidget {
  const MedicationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicationHistoryScreen> createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  late List<MedicineIntake> historyItems;

  @override
  void initState() {
    super.initState();
    historyItems = MockData.getMedicationHistory();
  }

  Map<String, List<MedicineIntake>> _groupByDate(List<MedicineIntake> items) {
    final Map<String, List<MedicineIntake>> grouped = {};
    for (var item in items) {
      final key = item.formattedDate;
      if (grouped[key] == null) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedHistory = _groupByDate(historyItems);
    final sortedDates = groupedHistory.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Medication History'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: historyItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: UbatKuTheme.primary.withAlpha((0.3 * 255).toInt()),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No medication history',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final items = groupedHistory[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Text(
                        date,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    ...items.map((intake) {
                      return MedicineHistoryItem(intake: intake);
                    }),
                    if (index < sortedDates.length - 1)
                      Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              },
            ),
    );
  }
}
