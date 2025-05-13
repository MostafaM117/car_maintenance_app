import 'package:flutter/material.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/forms/carform.dart' as form;
import 'package:car_maintenance/models/car_data.dart';
import 'package:car_maintenance/services/user_data_helper.dart';
import 'package:car_maintenance/widgets/ProgressStepsBar.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:car_maintenance/widgets/maintenance_date_picker.dart';
import 'package:car_maintenance/screens/Current_Screen/user_main_screen.dart';

class AddCarScreen extends StatefulWidget {
  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedMake;
  String? _selectedModel;
  int? _selectedYear;
  String? username;

  DateTime? lastMaintenanceDate;

  final TextEditingController mileageController = TextEditingController();
  final TextEditingController avgKmController = TextEditingController();

  final List<String> _carMakes = CarData.getAllMakes();

  bool isFormComplete = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    mileageController.addListener(checkFormCompletion);
    avgKmController.addListener(checkFormCompletion);
    loadUsername();
  }

  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }

  void checkFormCompletion() {
    setState(() {
      isFormComplete = _selectedMake != null &&
          _selectedModel != null &&
          _selectedYear != null &&
          mileageController.text.isNotEmpty &&
          avgKmController.text.isNotEmpty &&
          lastMaintenanceDate != null;
    });
  }

  int _filledFieldsCount() {
    int count = 0;
    if (_selectedMake != null) count++;
    if (_selectedModel != null) count++;
    if (_selectedYear != null) count++;
    if (mileageController.text.isNotEmpty) count++;
    if (avgKmController.text.isNotEmpty) count++;
    if (lastMaintenanceDate != null) count++;

    return count * 2;
  }

  void _submitForm() async {
    final carService = form.CarService(
      context: context,
      formKey: _formKey,
      mileageController: mileageController,
      avgKmPerMonthController: avgKmController,
      selectedMake: _selectedMake!,
      selectedModel: _selectedModel!,
      selectedYear: _selectedYear!,
      lastMaintenanceDate: lastMaintenanceDate,
    );

    await carService.submitForm((value) {
      setState(() {
        isLoading = value;
      });
    });
  }

  @override
  void dispose() {
    mileageController.dispose();
    avgKmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressStepsBar(
                  filledCount: _filledFieldsCount(),
                  totalCount: 12,
                ),
                const SizedBox(height: 24),
                Text(username != null ? 'Hi $username' : 'Hi User',
                    style: textStyleWhite.copyWith(fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  'Please fill in your car details to continue.',
                  style: textStyleGray,
                ),
                const SizedBox(height: 25),

                // Car Make
                buildDropdownField(
                  label: 'Car Make',
                  value: _selectedMake,
                  options: _carMakes,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMake = newValue;
                      _selectedModel = null;
                      _selectedYear = null;
                      checkFormCompletion();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Car Model
                buildDropdownField(
                  label: 'Car Model',
                  value: _selectedModel,
                  options: _selectedMake == null
                      ? []
                      : CarData.getModelsForMake(_selectedMake),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedModel = newValue;
                      _selectedYear = null;
                      checkFormCompletion();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Model Year
                buildDropdownField(
                  label: 'Model Year',
                  value: _selectedYear?.toString(),
                  options: (_selectedMake == null || _selectedModel == null)
                      ? []
                      : CarData.getYearsForModel(_selectedMake, _selectedModel)
                          .map((year) => year.toString())
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = int.tryParse(value!);
                      checkFormCompletion();
                    });
                  },
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
                const SizedBox(height: 20),

                // Avg usage
                buildTextField(
                  label: 'Average monthly usage (KM)',
                  controller: avgKmController,
                  hintText: 'Average (KM)',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter average usage';
                    }
                    FocusScope.of(context).unfocus();
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Maintenance date
                MaintenanceDatePicker(
                  onDateSelected: (DateTime date) {
                    setState(() {
                      lastMaintenanceDate = date;
                      FocusScope.of(context).unfocus();
                      checkFormCompletion();
                    });
                  },
                ),

                const SizedBox(height: 65),

                // Submit button
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : AnimatedButton(
                        'Submit',
                        isFormComplete
                            ? AppColors.buttonColor
                            : AppColors.secondaryText,
                        AppColors.buttonText,
                        onPressed: isFormComplete ? _submitForm : null,
                      ),

                const SizedBox(height: 20),

                // Dismiss button
                AnimatedButton(
                  'Dismiss',
                  AppColors.buttonText,
                  AppColors.buttonColor,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => UserMainScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
