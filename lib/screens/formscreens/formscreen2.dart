import 'package:car_maintenance/forms/carform.dart' as form;
// import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import 'package:car_maintenance/services/car_service.dart';
import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/ProgressStepsBar.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:car_maintenance/widgets/maintenance_date_picker.dart';
// import 'package:car_maintenance/services/car_service.dart';

class CarMileagePage extends StatefulWidget {
  final int filledSteps;
  final String selectedMake;
  final String selectedModel;
  final int selectedYear;

  const CarMileagePage({
    super.key,
    required this.filledSteps,
    required this.selectedMake,
    required this.selectedModel,
    required this.selectedYear,
  });

  @override
  State<CarMileagePage> createState() => _CarMileagePageState();
}

class _CarMileagePageState extends State<CarMileagePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController mileageController = TextEditingController();
  final TextEditingController avgKmController = TextEditingController();

  String? lastTireChange;
  String? lastBatteryChange;
  DateTime? lastMaintenanceDate;

  bool isFormComplete = false;
  bool isLoading = false;

  final List<String> options = [
    '1 month ago',
    '3 months ago',
    '6 months ago',
    '1 year ago',
  ];

  @override
  void initState() {
    super.initState();
    mileageController.addListener(checkFormCompletion);
    avgKmController.addListener(checkFormCompletion);
  }

  void checkFormCompletion() {
    setState(() {
      isFormComplete = mileageController.text.isNotEmpty &&
          avgKmController.text.isNotEmpty &&
          lastMaintenanceDate != null &&
          lastTireChange != null &&
          lastBatteryChange != null;
    });
  }

  int _filledFieldsCount() {
    int newCount = 0;
    if (mileageController.text.isNotEmpty) newCount++;
    if (avgKmController.text.isNotEmpty) newCount++;
    if (lastMaintenanceDate != null) newCount++;
    if (lastTireChange != null) newCount++;
    if (lastBatteryChange != null) newCount++;
    return widget.filledSteps + (newCount * 2);
  }

  @override
  void dispose() {
    mileageController.dispose();
    avgKmController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final carService = form.CarService(
      context: context,
      formKey: _formKey,
      mileageController: mileageController,
      avgKmPerMonthController: avgKmController,
      selectedMake: widget.selectedMake,
      selectedModel: widget.selectedModel,
      selectedYear: widget.selectedYear,
      lastMaintenanceDate: lastMaintenanceDate,
      lastTireChange: lastTireChange,
      lastBatteryChange: lastBatteryChange,
    );

    await carService.submitForm((value) {
      setState(() {
        isLoading = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProgressStepsBar(
                    filledCount: _filledFieldsCount(),
                    totalCount: 16,
                  ),
                  const SizedBox(height: 20),

                  // Mileage
                  buildTextField(
                    label: 'Current car mileage (Approx.)',
                    controller: mileageController,
                    hintText: 'Mileage (KM)',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mileage';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Avg usage
                  buildTextField(
                    label: 'Average monthly usage (KM)',
                    controller: avgKmController,
                    hintText: 'Average (KM)',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter average usage';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Last maintenance date picker
                  MaintenanceDatePicker(
                    onDateSelected: (DateTime date) {
                      setState(() {
                        lastMaintenanceDate = date;
                        checkFormCompletion();
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  // Tire change dropdown
                  buildDropdownField(
                    label: 'Last tires pair change was',
                    value: lastTireChange,
                    options: options,
                    onChanged: (val) {
                      setState(() {
                        lastTireChange = val;
                      });
                      checkFormCompletion();
                    },
                  ),
                  const SizedBox(height: 15),

                  // Battery change dropdown
                  buildDropdownField(
                    label: 'Last change of battery was',
                    value: lastBatteryChange,
                    options: options,
                    onChanged: (val) {
                      setState(() {
                        lastBatteryChange = val;
                      });
                      checkFormCompletion();
                    },
                  ),
                  const SizedBox(height: 50),

                  // Submit button
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : buildButton(
                          'Submit',
                          isFormComplete
                              ? AppColors.buttonColor
                              : AppColors.secondaryText,
                          AppColors.buttonText,
                          onPressed: isFormComplete
                              ? () {
                                  _submitForm();
                                }
                              : null,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
