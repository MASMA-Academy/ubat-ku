import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/theme/app_theme.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final Medicine? medicine;
  final Function(Medicine) onSave;

  const AddEditMedicineScreen({Key? key, this.medicine, required this.onSave})
    : super(key: key);

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _notesController;

  MedicineFrequency _selectedFrequency = MedicineFrequency.daily;
  DateTime _selectedStartDate = DateTime.now();
  DateTime? _selectedEndDate;
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  bool _reminderEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.name ?? '');
    _dosageController = TextEditingController(
      text: widget.medicine?.dosage ?? '',
    );
    _notesController = TextEditingController(
      text: widget.medicine?.notes ?? '',
    );

    if (widget.medicine != null) {
      _selectedFrequency = widget.medicine!.frequency;
      _selectedStartDate = widget.medicine!.startDate;
      _selectedEndDate = widget.medicine!.endDate;
      _reminderEnabled = widget.medicine!.reminderEnabled;
      _selectedTime = TimeOfDay(hour: 8, minute: 0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMedicine() {
    if (_nameController.text.isEmpty || _dosageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final medicine = Medicine(
      id: widget.medicine?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      dosage: _dosageController.text,
      frequency: _selectedFrequency,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      reminderEnabled: _reminderEnabled,
    );

    widget.onSave(medicine);
  }

  Future<void> _selectDate(bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _selectedStartDate
          : _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = selectedDate;
        } else {
          _selectedEndDate = selectedDate;
        }
      });
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicine == null ? 'Add Medicine' : 'Edit Medicine'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Name
              Text(
                'Medicine Name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Paracetamol',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Dosage
              Text('Dosage', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              TextField(
                controller: _dosageController,
                decoration: InputDecoration(
                  hintText: 'e.g., 500mg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Frequency
              Text('Frequency', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: UbatKuTheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<MedicineFrequency>(
                  value: _selectedFrequency,
                  isExpanded: true,
                  underline: SizedBox(),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  onChanged: (MedicineFrequency? value) {
                    if (value != null) {
                      setState(() {
                        _selectedFrequency = value;
                      });
                    }
                  },
                  items: MedicineFrequency.values.map((
                    MedicineFrequency frequency,
                  ) {
                    return DropdownMenuItem<MedicineFrequency>(
                      value: frequency,
                      child: Text(frequency.displayName),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),

              // Reminder Time
              Text(
                'Reminder Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: UbatKuTheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    _selectedTime.format(context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(Icons.access_time, color: UbatKuTheme.primary),
                  onTap: _selectTime,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 20),

              // Start Date
              Text(
                'Start Date',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: UbatKuTheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    '${_selectedStartDate.day}/${_selectedStartDate.month}/${_selectedStartDate.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.calendar_today,
                    color: UbatKuTheme.primary,
                  ),
                  onTap: () => _selectDate(true),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 20),

              // End Date
              Text(
                'End Date (Optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: UbatKuTheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    _selectedEndDate == null
                        ? 'No end date'
                        : '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _selectedEndDate == null
                          ? UbatKuTheme.onSurfaceVariant
                          : UbatKuTheme.onSurface,
                    ),
                  ),
                  trailing: Icon(
                    Icons.calendar_today,
                    color: UbatKuTheme.primary,
                  ),
                  onTap: () => _selectDate(false),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 20),

              // Notes
              Text('Notes', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'e.g., Take with food',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              // Reminder Toggle
              CheckboxListTile(
                title: Text('Enable Reminder'),
                value: _reminderEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _reminderEnabled = value ?? true;
                  });
                },
                activeColor: UbatKuTheme.primary,
              ),
              SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveMedicine,
                  child: Text(
                    widget.medicine == null
                        ? 'Add Medicine'
                        : 'Update Medicine',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
