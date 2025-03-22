import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/ProgressStepsBar.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/maintenance_date_picker.dart';

class CarMileagePage extends StatefulWidget {
  final int filledSteps;

  const CarMileagePage({super.key, required this.filledSteps});

  @override
  State<CarMileagePage> createState() => _CarMileagePageState();
}

class _CarMileagePageState extends State<CarMileagePage> {
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController avgerageController = TextEditingController();

  // String? avgMonthlyUsage;
  String? lastMaintenance;
  String? lastTireChange;
  String? lastBatteryChange;

  final List<String> options = [
    '1 month ago',
    '3 months ago',
    '6 months ago',
    '1 year ago'
  ];

  bool isFormComplete = false;

  void checkFormCompletion() {
    setState(() {
      isFormComplete = mileageController.text.isNotEmpty &&
          avgerageController.text.isNotEmpty &&
          lastMaintenance != null &&
          lastTireChange != null &&
          lastBatteryChange != null;
    });
  }

  int _filledFieldsCount() {
    int count = widget.filledSteps;

    if (mileageController.text.isNotEmpty) count++;
    if (avgerageController.text.isNotEmpty) count++;
    if (lastMaintenance != null) count++;
    if (lastTireChange != null) count++;
    if (lastBatteryChange != null) count++;

    return count;
  }

  @override
  void initState() {
    super.initState();
    mileageController.addListener(checkFormCompletion);
    avgerageController.addListener(checkFormCompletion);
  }

  @override
  void dispose() {
    mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressStepsBar(
                  filledCount: _filledFieldsCount(),
                  totalCount: 8,
                ),
                const SizedBox(height: 24),
                buildTextField(
                  label: 'Current car mileage (Approx.)',
                  controller: mileageController,
                  hintText: 'Mileage (KM)',
                ),
                const SizedBox(height: 24),
                buildTextField(
                  label: 'Average monthly usage (KM)',
                  controller: avgerageController,
                  hintText: 'Average (KM)',
                ),
                const SizedBox(height: 24),
                MaintenanceDatePicker(
                  onDateSelected: (DateTime date) {
                    setState(() {
                      lastMaintenance =
                          '${date.day}/${date.month}/${date.year}';
                      checkFormCompletion();
                    });
                  },
                ),
                const SizedBox(height: 24),
                buildDropdownField(
                  label: 'Last tires change was at a mileage reading of',
                  value: lastTireChange,
                  options: options,
                  onChanged: (val) {
                    setState(() => lastTireChange = val);
                    checkFormCompletion();
                  },
                ),
                const SizedBox(height: 24),
                buildDropdownField(
                  label: 'Last change of battery',
                  value: lastBatteryChange,
                  options: options,
                  onChanged: (val) {
                    setState(() => lastBatteryChange = val);
                    checkFormCompletion();
                  },
                ),
                const SizedBox(height: 32),
                buildButton(
                  'Submit',
                  isFormComplete
                      ? AppColors.buttonColor
                      : AppColors.secondaryText,
                  AppColors.buttonText,
                  onPressed: isFormComplete
                      ? () {
                          Navigator.pop(context);
                        }
                      : () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
