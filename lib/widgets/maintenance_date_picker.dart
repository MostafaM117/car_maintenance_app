import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_widgets.dart';

class MaintenanceDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const MaintenanceDatePicker({super.key, required this.onDateSelected});

  @override
  _MaintenanceDatePickerState createState() => _MaintenanceDatePickerState();
}

class _MaintenanceDatePickerState extends State<MaintenanceDatePicker> {
  DateTime? lastMaintenanceDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastMaintenanceDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != lastMaintenanceDate) {
      setState(() {
        lastMaintenanceDate = picked;
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last periodic Maintenance ',
          style: textStyleWhite
        ),
        // const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: AppColors.secondaryText,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: AppColors.borderSide,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              lastMaintenanceDate == null
                  ? 'Select Maintenance Date'
                  : '${lastMaintenanceDate!.day}/${lastMaintenanceDate!.month}/${lastMaintenanceDate!.year}',
              style: textStyleGray,
            ),
          ),
        ),
      ],
    );
  }
}
