import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/data/database_helper.dart';
import 'package:ubatku/widgets/medicine_card.dart';
import 'package:ubatku/theme/app_theme.dart';

class MedicationHistoryScreen extends StatefulWidget {
  const MedicationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicationHistoryScreen> createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  final _db = DatabaseHelper.instance;
  List<MedicineIntake> historyItems = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final loaded = await _db.getMedicationHistory();
    if (!mounted) return;
    setState(() {
      historyItems = loaded;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicineIntake> get _filteredHistoryItems {
    if (_searchQuery.isEmpty) return historyItems;
    final query = _searchQuery.toLowerCase();
    return historyItems
        .where((item) => item.medicineName.toLowerCase().contains(query))
        .toList();
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
    final filteredItems = _filteredHistoryItems;
    final groupedHistory = _groupByDate(filteredItems);
    final sortedDates = groupedHistory.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Medication History'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: UbatKuTheme.primary))
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by medicine name',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.history
                              : Icons.search_off,
                          size: 64,
                          color: UbatKuTheme.primary.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No medication history'
                              : 'No results for "$_searchQuery"',
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
          ),
        ],
      ),
    );
  }
}
