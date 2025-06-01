import 'dart:io';
import 'package:flutter/material.dart';
import '../Back-end/firestore_service.dart';
import '../constants/app_colors.dart';
import '../models/MaintID.dart';
import '../notifications/notification.dart';
// import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';

class AddMaintenance extends StatefulWidget {
  const AddMaintenance({super.key});

  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

final TextEditingController maintenanceController = TextEditingController();
late FirestoreService firestoreService;

class _AddMaintenanceState extends State<AddMaintenance> {
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? _pageTitle;
  bool _isEditingTitle = false;
  String? _status = 'Upcoming'; // Default status

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(MaintID());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingTitle = true;
                      });
                    },
                    child: _isEditingTitle
                        ? Container(
                            width: 250,
                            child: TextField(
                              controller: TextEditingController(
                                  text: _pageTitle ?? "Maintenance Name"),
                              style: TextStyle(
                                color: const Color(0xFFDA1F11),
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              textAlign: TextAlign.center,
                              onSubmitted: (value) {
                                setState(() {
                                  _pageTitle = value;
                                  _isEditingTitle = false;
                                });
                              },
                              autofocus: true,
                            ),
                          )
                        : Text(
                            _pageTitle ?? "Maintenance Name",
                            style: TextStyle(
                              color: const Color(0xFFDA1F11),
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    label: 'Mileage',
                    hintText: 'Current mileage',
                    controller: mileageController,
                  ),
                  const SizedBox(height: 12), // Date Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maintenance Date',
                        style: textStyleWhite.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryText,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.borderSide),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate != null
                                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                                    : 'Select Date',
                                style: textStyleGray,
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
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    label: ' Maintenance Status',
                  ),
                  const SizedBox(height: 12),
                  // Attachments Field
                  buildAttachmentPicker(
                    onAttachmentPicked: (File file) {
                      print('Attachment selected: ${file.path}');
                    },
                  ),

                  const SizedBox(height: 12),

                  // Description Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: textStyleWhite.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 345,
                        height: 200,
                        padding: EdgeInsets.all(9),
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
                        child: TextField(
                            controller: descriptionController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration.collapsed(
                              hintText: '',
                            ),
                            style: textStyleWhite),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        popUpBotton(
                          'Cancel',
                          AppColors.primaryText,
                          AppColors.buttonText,
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        popUpBotton(
                          "save",
                          AppColors.buttonColor,
                          AppColors.buttonText,
                          onPressed: () {
                            if (selectedDate != null) {
                              if (_status == 'Upcoming') {
                                firestoreService.addMaintenance(
                                    descriptionController.text,
                                    false,
                                    mileageController.text.isNotEmpty
                                        ? int.parse(mileageController.text)
                                        : 0,
                                    selectedDate!);
                              }
                              if (_status == 'Completed') {
                                firestoreService.addSpecialMaintenance(
                                    descriptionController.text,
                                    true, // Set isDone to true for completed items
                                    mileageController.text.isNotEmpty
                                        ? int.parse(mileageController.text)
                                        : 0,
                                    selectedDate!);
                              }
                              NotiService().showNotification(
                                title: 'Maintenance Added!',
                                body: descriptionController.text,
                                type: 'maintenance',
                              );
                            } else {
                              // Handle case when date is not selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please select a date')),
                              );
                            }
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
