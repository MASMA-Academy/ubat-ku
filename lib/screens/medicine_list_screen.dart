import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/data/mock_data.dart';
import 'package:ubatku/widgets/medicine_card.dart';
import 'package:ubatku/screens/add_edit_medicine_screen.dart';
import 'package:ubatku/theme/app_theme.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  late List<Medicine> medicines;

  @override
  void initState() {
    super.initState();
    medicines = List.from(MockData.medicines);
  }

  void _addMedicine(Medicine medicine) {
    setState(() {
      medicines.add(medicine);
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editMedicine(int index, Medicine medicine) {
    setState(() {
      medicines[index] = medicine;
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteMedicine(int index) {
    final medicine = medicines[index];
    setState(() {
      medicines.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} deleted'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              medicines.insert(index, medicine);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Medicines'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: medicines.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication,
                    size: 64,
                    color: UbatKuTheme.primary.withAlpha((0.3 * 255).toInt()),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No medicines yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first medicine to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: UbatKuTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return MedicineListCard(
                  medicine: medicine,
                  onEdit: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEditMedicineScreen(
                          medicine: medicine,
                          onSave: (editedMedicine) {
                            _editMedicine(index, editedMedicine);
                          },
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Medicine'),
                          content: Text(
                            'Are you sure you want to delete ${medicine.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteMedicine(index);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: UbatKuTheme.error),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
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
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
