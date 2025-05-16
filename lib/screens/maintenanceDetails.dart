import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Back-end/firestore_service.dart';
import '../models/MaintID.dart';
// import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';

class MaintenanceDetailsPage extends StatefulWidget {
  final MaintenanceList maintenanceItem;

  const MaintenanceDetailsPage({super.key, required this.maintenanceItem});

  @override
  State<MaintenanceDetailsPage> createState() => _MaintenanceDetailsPageState();
}

class _MaintenanceDetailsPageState extends State<MaintenanceDetailsPage> {
  late FirestoreService firestoreService;
  late TextEditingController descriptionController;
  late TextEditingController mileageController;
  String _status = 'Upcoming';
  bool _isEditing = false;
  DateTime _selectedDate = DateTime.now();
  bool isEditingMileage = false;
  bool isEditingDescription = false;
  
  // For calculating expected date
  int currentCarMileage = 0;
  int avgKmPerMonth = 500; // Default value

  late FocusNode mileageFocusNode;
  late FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(MaintID());
    descriptionController =
        TextEditingController(text: widget.maintenanceItem.description);
    mileageController =
        TextEditingController(text: widget.maintenanceItem.mileage.toString());
    _status = widget.maintenanceItem.isDone ? 'Completed' : 'Upcoming';
    _selectedDate = widget.maintenanceItem.expectedDate;

    mileageFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    
    // Get current car mileage and avg km per month
    _fetchCarDetails();
  }
  
  // Fetch current car details to calculate expected date
  void _fetchCarDetails() async {
    try {
      // Get the current car ID from MaintID
      final maintID = MaintID();
      final carMake = maintID.selectedMake;
      final carModel = maintID.selectedModel;
      final carYear = maintID.selectedYear;
      
      // Query Firestore to get the car details
      final carsQuery = await FirebaseFirestore.instance
          .collection('cars')
          .where('make', isEqualTo: carMake)
          .where('model', isEqualTo: carModel)
          .where('year', isEqualTo: int.tryParse(carYear) ?? 0)
          .limit(1)
          .get();
      
      if (carsQuery.docs.isNotEmpty) {
        final carData = carsQuery.docs.first.data();
        setState(() {
          // Handle any type for mileage and avgKmPerMonth safely
          final mileageValue = carData['mileage'];
          if (mileageValue != null) {
            if (mileageValue is int) {
              currentCarMileage = mileageValue;
            } else if (mileageValue is double) {
              currentCarMileage = mileageValue.toInt();
            } else if (mileageValue is String) {
              currentCarMileage = int.tryParse(mileageValue) ?? 0;
            }
          }
          
          final avgKmValue = carData['avgKmPerMonth'];
          if (avgKmValue != null) {
            if (avgKmValue is int) {
              avgKmPerMonth = avgKmValue;
            } else if (avgKmValue is double) {
              avgKmPerMonth = avgKmValue.toInt();
            } else if (avgKmValue is String) {
              avgKmPerMonth = int.tryParse(avgKmValue) ?? 500;
            }
          }
          
          print("📊 Fetched car details - Mileage: $currentCarMileage, Avg KM/Month: $avgKmPerMonth");
        });
      }
    } catch (e) {
      print("❌ Error fetching car details: $e");
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    mileageController.dispose();
    mileageFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Check if status changed to Completed
    if (_status == 'Completed' && !widget.maintenanceItem.isDone) {
      // Move to history instead of updating
      firestoreService.moveToHistory(widget.maintenanceItem.id);
    } else {
      // Update maintenance item with new values
      firestoreService.updateMaintenance(
        widget.maintenanceItem.id,
        descriptionController.text,
        int.parse(mileageController.text),
        _selectedDate,
        _status == 'Completed',
      );
    }

    setState(() {
      _isEditing = false;
      isEditingMileage = false;
      isEditingDescription = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Maintenance updated successfully')),
    );

    // If marked as completed, navigate back
    if (_status == 'Completed') {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Maintenance Details',
                      style: TextStyle(
                        color: AppColors.buttonColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Maintenance Type', // هنا اسم الحقل
                                    style: textStyleWhite.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 45,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // حقل الـ TextField
                                        Expanded(
                                          child: TextField(
                                            controller: mileageController,
                                            enabled: isEditingMileage,
                                            focusNode: mileageFocusNode,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isCollapsed: true,
                                              hintText:
                                                  'Current mileage', // النص المساعد
                                              hintStyle: textStyleGray.copyWith(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            style: textStyleGray,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                          ),
                                        ),
                                        // أيقونة التعديل داخل الـ Container
                                        if (_isEditing)
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isEditingMileage = true;
                                              });
                                              Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                mileageFocusNode
                                                    .requestFocus(); // فتح الكيبورد عند الضغط على الأيقونة
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons/edit.svg',
                                              width: 25,
                                              height: 25,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      AppColors.primaryText,
                                                      BlendMode.srcIn),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expected Date',
                              style: textStyleWhite.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap:
                                  null, // مش محتاجين onTap هنا لأنه هيشتغل من الأيقونة
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // Show calculated expected date if we have car mileage data
                                      currentCarMileage > 0
                                          ? widget.maintenanceItem.formatExpectedDate(currentCarMileage, avgKmPerMonth)
                                          : _selectedDate.toString().split(' ')[0],
                                      style: textStyleGray,
                                    ),
                                    if (_isEditing)
                                      GestureDetector(
                                        onTap: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: _selectedDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null &&
                                              picked != _selectedDate) {
                                            setState(() {
                                              _selectedDate = picked;
                                            });
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icons/edit.svg',
                                          width: 25,
                                          height: 25,
                                          colorFilter: const ColorFilter.mode(
                                              AppColors.primaryText,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        buildDropdownField(
                          value: _status,
                          options: ['Upcoming', 'Completed'],
                          onChanged: null,
                          label: 'Maintenance Status',
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: textStyleWhite.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  padding: const EdgeInsets.all(15),
                                  decoration: ShapeDecoration(
                                    color: AppColors.secondaryText,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: AppColors.borderSide),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: descriptionController,
                                    maxLines: null,
                                    expands: true,
                                    enabled: isEditingDescription,
                                    focusNode: descriptionFocusNode,
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ''),
                                    style: textStyleWhite,
                                  ),
                                ),
                                if (_isEditing)
                                  Positioned(
                                    top: 15,
                                    right: 15,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isEditingDescription = true;
                                        });
                                        Future.delayed(
                                            Duration(milliseconds: 100), () {
                                          descriptionFocusNode.requestFocus();
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/edit.svg',
                                        width: 25,
                                        height: 25,
                                        colorFilter: const ColorFilter.mode(
                                            AppColors.primaryText,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              popUpBotton(
                                'Back',
                                AppColors.primaryText,
                                AppColors.buttonText,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              popUpBotton(
                                _isEditing ? "Save" : "Edit",
                                AppColors.buttonColor,
                                AppColors.buttonText,
                                onPressed: () {
                                  if (_isEditing) {
                                    _saveChanges();
                                  } else {
                                    setState(() {
                                      _isEditing = true;
                                      isEditingMileage = false;
                                      isEditingDescription = false;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
