import 'package:flutter/material.dart';
import 'package:ubatku/models/medicine.dart';
import 'package:ubatku/theme/app_theme.dart';

class MedicineCard extends StatelessWidget {
  final MedicineReminder reminder;
  final Medicine medicine;
  final VoidCallback? onTap;
  final Function(MedicineStatus)? onStatusChanged;

  const MedicineCard({
    Key? key,
    required this.reminder,
    required this.medicine,
    this.onTap,
    this.onStatusChanged,
  }) : super(key: key);

  Color _getStatusColor(MedicineStatus status) {
    switch (status) {
      case MedicineStatus.taken:
        return UbatKuTheme.secondary;
      case MedicineStatus.skipped:
        return UbatKuTheme.error;
      case MedicineStatus.upcoming:
        return UbatKuTheme.tertiary;
      case MedicineStatus.missed:
        return UbatKuTheme.error;
    }
  }

  IconData _getStatusIcon(MedicineStatus status) {
    switch (status) {
      case MedicineStatus.taken:
        return Icons.check_circle;
      case MedicineStatus.skipped:
        return Icons.cancel;
      case MedicineStatus.upcoming:
        return Icons.schedule;
      case MedicineStatus.missed:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time =
        '${reminder.scheduledTime.hour.toString().padLeft(2, '0')}:${reminder.scheduledTime.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getStatusColor(
              reminder.status,
            ).withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(reminder.status),
            color: _getStatusColor(reminder.status),
          ),
        ),
        title: Text(
          medicine.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              '${medicine.dosage} • $time',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 4),
            Text(
              reminder.status.displayName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _getStatusColor(reminder.status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: reminder.status == MedicineStatus.upcoming
            ? PopupMenuButton(
                onSelected: (MedicineStatus status) {
                  onStatusChanged?.call(status);
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: MedicineStatus.taken,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: UbatKuTheme.secondary),
                        SizedBox(width: 8),
                        Text('Mark Taken'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: MedicineStatus.skipped,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, color: UbatKuTheme.error),
                        SizedBox(width: 8),
                        Text('Mark Skipped'),
                      ],
                    ),
                  ),
                ],
              )
            : Icon(
                _getStatusIcon(reminder.status),
                color: _getStatusColor(reminder.status),
              ),
        onTap: onTap,
      ),
    );
  }
}

class MedicineListCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineListCard({
    Key? key,
    required this.medicine,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      medicine.dosage,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: medicine.isActive
                        ? UbatKuTheme.secondary.withAlpha((0.1 * 255).toInt())
                        : UbatKuTheme.error.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    medicine.isActive ? 'Active' : 'Inactive',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: medicine.isActive
                          ? UbatKuTheme.secondary
                          : UbatKuTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Frequency: ${medicine.frequency.displayName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 4),
            Text(
              'Start: ${_formatDate(medicine.startDate)}${medicine.endDate != null ? ' - End: ${_formatDate(medicine.endDate!)}' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (medicine.notes != null && medicine.notes!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Notes: ${medicine.notes}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onEdit, child: Text('Edit')),
                SizedBox(width: 8),
                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    'Delete',
                    style: TextStyle(color: UbatKuTheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class MedicineHistoryItem extends StatelessWidget {
  final MedicineIntake intake;

  const MedicineHistoryItem({Key? key, required this.intake}) : super(key: key);

  Color _getStatusColor(MedicineStatus status) {
    switch (status) {
      case MedicineStatus.taken:
        return UbatKuTheme.secondary;
      case MedicineStatus.skipped:
        return UbatKuTheme.error;
      case MedicineStatus.upcoming:
        return UbatKuTheme.tertiary;
      case MedicineStatus.missed:
        return UbatKuTheme.error;
    }
  }

  IconData _getStatusIcon(MedicineStatus status) {
    switch (status) {
      case MedicineStatus.taken:
        return Icons.check_circle;
      case MedicineStatus.skipped:
        return Icons.cancel;
      case MedicineStatus.upcoming:
        return Icons.schedule;
      case MedicineStatus.missed:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getStatusColor(
                intake.status,
              ).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(intake.status),
              color: _getStatusColor(intake.status),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intake.medicineName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 4),
                Text(
                  '${intake.dosage} • ${intake.formattedTime}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(
                intake.status,
              ).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              intake.status.displayName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _getStatusColor(intake.status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
