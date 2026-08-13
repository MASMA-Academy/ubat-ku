import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/data/database_helper.dart';
import 'package:ubatku/widgets/medicine_card.dart';
import 'package:ubatku/screens/add_edit_medicine_screen.dart';
import 'package:ubatku/theme/app_theme.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final _db = DatabaseHelper.instance;
  List<Medicine> medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final loaded = await _db.getMedicines();
    if (!mounted) return;
    setState(() {
      medicines = loaded;
      _isLoading = false;
    });
  }

  Future<void> _addMedicine(Medicine medicine) async {
    await _db.insertMedicine(medicine);
    await _loadMedicines();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editMedicine(Medicine medicine) async {
    await _db.updateMedicine(medicine);
    await _loadMedicines();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteMedicine(Medicine medicine) async {
    await _db.deleteMedicine(medicine.id);
    await _loadMedicines();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              UbatKuTheme.primary.withAlpha((0.08 * 255).toInt()),
              UbatKuTheme.surface,
            ],
          ),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: UbatKuTheme.primary),
              )
            : medicines.isEmpty
            ? _buildEmptyState(context)
            : _buildMedicinesList(context),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'My Medicines',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      backgroundColor: UbatKuTheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withAlpha((0.3 * 255).toInt()),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '${medicines.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Empty Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      UbatKuTheme.primary.withAlpha((0.15 * 255).toInt()),
                      UbatKuTheme.primary.withAlpha((0.08 * 255).toInt()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: UbatKuTheme.primary.withAlpha((0.2 * 255).toInt()),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  size: 60,
                  color: UbatKuTheme.primary,
                ),
              ),
              SizedBox(height: 24),

              // Title
              Text(
                'No Medicines Yet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: UbatKuTheme.onSurface,
                ),
              ),
              SizedBox(height: 12),

              // Subtitle
              Text(
                'Start building your medicine schedule',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: UbatKuTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),

              // Helper Text
              Text(
                'Add your first medicine to get started with your personalized health routine',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: UbatKuTheme.onSurfaceVariant.withAlpha(
                    (0.7 * 255).toInt(),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // CTA Button
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [UbatKuTheme.primary, UbatKuTheme.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: UbatKuTheme.primary.withAlpha((0.3 * 255).toInt()),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddEditMedicineScreen(onSave: _addMedicine),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add Medicine',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicinesList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: BouncingScrollPhysics(),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _buildMedicineItem(context, medicine),
        );
      },
    );
  }

  Widget _buildMedicineItem(BuildContext context, Medicine medicine) {
    return MedicineListCard(
      medicine: medicine,
      onEdit: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEditMedicineScreen(
              medicine: medicine,
              onSave: (editedMedicine) {
                _editMedicine(editedMedicine);
              },
            ),
          ),
        );
      },
      onDelete: () {
        _showDeleteConfirmation(context, medicine);
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Medicine medicine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: UbatKuTheme.error.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: UbatKuTheme.error.withAlpha((0.2 * 255).toInt()),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: UbatKuTheme.error,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Title
                  Text(
                    'Delete Medicine?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: UbatKuTheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Message
                  Text(
                    'Are you sure you want to delete ${medicine.name}? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: UbatKuTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 28),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: UbatKuTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: UbatKuTheme.outline.withAlpha(
                                    (0.2 * 255).toInt(),
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: UbatKuTheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              _deleteMedicine(medicine);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: UbatKuTheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Delete',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UbatKuTheme.primary, UbatKuTheme.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: UbatKuTheme.primary.withAlpha((0.4 * 255).toInt()),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditMedicineScreen(onSave: _addMedicine),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
