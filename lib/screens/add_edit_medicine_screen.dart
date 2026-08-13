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
    final isEditing = widget.medicine != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Medicine' : 'Add Medicine'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(context, isEditing),
                SizedBox(height: 28),

                // Medicine Details Section
                _buildSectionCard(
                  context: context,
                  title: 'Medicine Details',
                  icon: Icons.local_pharmacy_outlined,
                  children: [
                    _buildInputField(
                      context: context,
                      label: 'Medicine Name *',
                      hint: 'e.g., Paracetamol',
                      controller: _nameController,
                      icon: Icons.medication_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      context: context,
                      label: 'Dosage *',
                      hint: 'e.g., 500mg',
                      controller: _dosageController,
                      icon: Icons.science_outlined,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Schedule Section
                _buildSectionCard(
                  context: context,
                  title: 'Schedule',
                  icon: Icons.schedule_outlined,
                  children: [
                    _buildDropdownField(
                      context: context,
                      label: 'Frequency',
                      value: _selectedFrequency,
                      icon: Icons.repeat_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildDateTimeRow(context),
                  ],
                ),
                SizedBox(height: 20),

                // Duration Section
                _buildSectionCard(
                  context: context,
                  title: 'Duration',
                  icon: Icons.date_range_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateSelector(
                            context: context,
                            label: 'Start Date',
                            date: _selectedStartDate,
                            onTap: () => _selectDate(true),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildDateSelector(
                            context: context,
                            label: 'End Date',
                            date: _selectedEndDate,
                            onTap: () => _selectDate(false),
                            isOptional: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Additional Info Section
                _buildSectionCard(
                  context: context,
                  title: 'Additional Information',
                  icon: Icons.info_outline,
                  children: [
                    _buildNotesField(context),
                    SizedBox(height: 16),
                    _buildReminderToggle(context),
                  ],
                ),
                SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(context, isEditing),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isEditing) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UbatKuTheme.primary.withAlpha((0.12 * 255).toInt()),
            UbatKuTheme.primary.withAlpha((0.06 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: UbatKuTheme.primary.withAlpha((0.2 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [UbatKuTheme.primary, UbatKuTheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isEditing ? Icons.edit_note : Icons.add_circle,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Update Your Medicine' : 'Add New Medicine',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UbatKuTheme.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Modify the medicine details'
                      : 'Fill in the details to add a new medicine',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: UbatKuTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.95 * 255).toInt()),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withAlpha((0.5 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: UbatKuTheme.primary.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: UbatKuTheme.primary, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UbatKuTheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: UbatKuTheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: UbatKuTheme.primary, size: 20),
            prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
            filled: true,
            fillColor: UbatKuTheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: UbatKuTheme.outline.withAlpha((0.3 * 255).toInt()),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: UbatKuTheme.outline.withAlpha((0.2 * 255).toInt()),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: UbatKuTheme.primary, width: 2),
            ),
            contentPadding: EdgeInsets.only(
              left: 12,
              right: 16,
              top: 14,
              bottom: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required MedicineFrequency value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: UbatKuTheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: UbatKuTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: UbatKuTheme.outline.withAlpha((0.2 * 255).toInt()),
            ),
          ),
          child: DropdownButton<MedicineFrequency>(
            value: value,
            isExpanded: true,
            underline: SizedBox(),
            padding: EdgeInsets.only(left: 48, right: 16),
            icon: Icon(Icons.expand_more, color: UbatKuTheme.primary),
            onChanged: (MedicineFrequency? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedFrequency = newValue;
                });
              }
            },
            items: MedicineFrequency.values.map((frequency) {
              return DropdownMenuItem<MedicineFrequency>(
                value: frequency,
                child: Text(
                  frequency.displayName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
            hint: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: [
                  Icon(icon, color: UbatKuTheme.primary, size: 20),
                  SizedBox(width: 12),
                  Text('Select frequency'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeRow(BuildContext context) {
    return Row(children: [Expanded(child: _buildTimeSelector(context))]);
  }

  Widget _buildTimeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Time',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: UbatKuTheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: UbatKuTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: UbatKuTheme.outline.withAlpha((0.2 * 255).toInt()),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: UbatKuTheme.primary, size: 20),
                SizedBox(width: 12),
                Text(
                  _selectedTime.format(context),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: UbatKuTheme.primary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    final displayDate = date == null
        ? 'No date'
        : '${date.day}/${date.month}/${date.year}';
    final isSet = date != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: UbatKuTheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: UbatKuTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSet
                    ? UbatKuTheme.primary.withAlpha((0.3 * 255).toInt())
                    : UbatKuTheme.outline.withAlpha((0.2 * 255).toInt()),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isSet
                      ? UbatKuTheme.primary
                      : UbatKuTheme.onSurfaceVariant,
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    displayDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSet
                          ? UbatKuTheme.onSurface
                          : UbatKuTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return _buildInputField(
      context: context,
      label: 'Notes (Optional)',
      hint: 'e.g., Take with food, avoid dairy',
      controller: _notesController,
      icon: Icons.description_outlined,
      maxLines: 3,
    );
  }

  Widget _buildReminderToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _reminderEnabled
            ? UbatKuTheme.primary.withAlpha((0.08 * 255).toInt())
            : UbatKuTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _reminderEnabled
              ? UbatKuTheme.primary.withAlpha((0.3 * 255).toInt())
              : UbatKuTheme.outline.withAlpha((0.2 * 255).toInt()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: _reminderEnabled
                ? UbatKuTheme.primary
                : UbatKuTheme.onSurfaceVariant,
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Reminder',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: UbatKuTheme.onSurface,
                  ),
                ),
                Text(
                  'Get notified when it\'s time to take your medicine',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: UbatKuTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Switch(
            value: _reminderEnabled,
            onChanged: (bool value) {
              setState(() {
                _reminderEnabled = value;
              });
            },
            activeThumbColor: UbatKuTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary Button
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
              onTap: _saveMedicine,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isEditing ? Icons.check : Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      isEditing ? 'Update Medicine' : 'Add Medicine',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
        SizedBox(height: 12),

        // Secondary Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: UbatKuTheme.outline.withAlpha((0.3 * 255).toInt()),
                  width: 1,
                ),
              ),
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: UbatKuTheme.onSurface,
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
}
