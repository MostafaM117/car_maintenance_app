import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/user_data_helper.dart';
import '../../widgets/ProgressStepsBar.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/transition_widgets.dart';
import 'formscreen2.dart';

class AddCarScreen extends StatefulWidget {
  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  String? _selectedMake;
  String? _selectedModel;
  int? _selectedYear;

  final Map<String, List<String>> _carModels = {
    'Chevrolet': ['Camaro', 'Aveo'],
    'Hyundai': ['Elantra', 'Sonata'],
  };

  final List<int> _years = [2020, 2021, 2022, 2023, 2024, 2025];
  String? username;
  bool get isFormComplete =>
      _selectedMake != null && _selectedModel != null && _selectedYear != null;
  // loadUsername();

  int _filledFieldsCount() {
    int count = 0;
    if (_selectedMake != null) count++;
    if (_selectedModel != null) count++;
    if (_selectedYear != null) count++;
    return count * 2;
  }

  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              ProgressStepsBar(
                filledCount: _filledFieldsCount(),
                totalCount: 16,
              ),
              const SizedBox(height: 24),

              // User Greeting
              Text(
                username != null ? 'Hi $username' : 'Hi User',
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please confirm your car details so our support team can reach you soon.',
                style: textStyleGray,
              ),
              const SizedBox(height: 20),

              // Car Make
              buildDropdownField(
                label: 'Car Make',
                value: _selectedMake,
                options: _carModels.keys.toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMake = newValue;
                    _selectedModel = null; // Reset model when make changes
                  });
                },
              ),

              const SizedBox(height: 15),

              // Car Model
              buildDropdownField(
                  label: 'Car Model',
                  value: _selectedModel,
                  options:
                      _selectedMake == null ? [] : _carModels[_selectedMake]!,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedModel = newValue;
                    });
                  }),

              const SizedBox(height: 15),

              // Model Year
              buildDropdownField(
                label: 'Model Year',
                value: _selectedYear?.toString(),
                options: _years.map((year) => year.toString()).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = int.tryParse(value!);
                  });
                },
              ),

              const SizedBox(height: 60),

              // Continue Button
              buildButton(
                'Continue',
                isFormComplete
                    ? AppColors.buttonColor
                    : AppColors.borderSide,
                AppColors.buttonText,
                onPressed: isFormComplete
                    ? () {
                        Navigator.push(
                          context,
                          FadeinTransition(CarMileagePage(
                            filledSteps: _filledFieldsCount(),
                            selectedMake: _selectedMake!,
                            selectedModel: _selectedModel!,
                            selectedYear: _selectedYear!,
                          )),
                        );
                      }
                    : () {},
              ),

              const SizedBox(height: 20),

              // Dismiss Button
              buildButton(
                'Dismiss',
                AppColors.buttonText,
                AppColors.buttonColor,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainScreen()), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
