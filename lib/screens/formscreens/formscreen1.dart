import 'package:flutter/material.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/forms/carform.dart' as form;
import 'package:car_maintenance/models/car_data.dart';
import 'package:car_maintenance/services/user_data_helper.dart';
import 'package:car_maintenance/widgets/ProgressStepsBar.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:car_maintenance/widgets/maintenance_date_picker.dart';
import 'package:car_maintenance/screens/Current_Screen/user_main_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
                Text(
                    username != null
                        ? l10n.welcome(username!)
                        : l10n.welcome("User"),
                    style: textStyleWhite.copyWith(fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  l10n.formWelcomeMessage,
                  style: textStyleGray,
                ),
                const SizedBox(height: 25),

                // Car Make
                buildDropdownField(
                  context: context,
                  label: l10n.brand,
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
                  context: context,
                  label: l10n.model,
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
                  context: context,
                  label: l10n.year,
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
                  label: l10n.currentMileageLabel,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(7),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: mileageController,
                  hintText: l10n.mileageHint,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterMileageError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Avg usage
                buildTextField(
                  label: l10n.avgMonthlyUsageLabel,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: avgKmController,
                  hintText: l10n.avgKmHint,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterAvgUsageError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Maintenance date
                MaintenanceDatePicker(
                  onDateSelected: (DateTime date) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      lastMaintenanceDate = date;
                      checkFormCompletion();
                    });
                  },
                ),

                const SizedBox(height: 65),

                // Submit button
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : buildButton(
                        l10n.submit,
                        isFormComplete
                            ? AppColors.buttonColor
                            : AppColors.secondaryText,
                        AppColors.buttonText,
                        onPressed: isFormComplete ? _submitForm : null,
                      ),

                const SizedBox(height: 20),

                // Dismiss button
                buildButton(
                  l10n.cancel,
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
