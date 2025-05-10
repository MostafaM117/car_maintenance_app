import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import '../Back-end/firestore_service.dart';
import '../models/MaintID.dart';
// import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';

class HistoryDetailsPage extends StatefulWidget {
  final MaintenanceList maintenanceItem;

  const HistoryDetailsPage({super.key, required this.maintenanceItem});

  @override
  State<HistoryDetailsPage> createState() => _HistoryDetailsPage();
}

class _HistoryDetailsPage extends State<HistoryDetailsPage> {
  late FirestoreService firestoreService;
  late TextEditingController descriptionController;
  late TextEditingController mileageController;
  String _status = 'Upcoming';
  bool _isEditing = false;
  DateTime _selectedDate = DateTime.now();

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
  }

  @override
  void dispose() {
    descriptionController.dispose();
    mileageController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Check if status changed to Completed
    if (_status == 'Completed' && !widget.maintenanceItem.isDone) {
      // Move to history instead of updating
      firestoreService.moveToHistory(widget.maintenanceItem.id);
    } else {
      // Update maintenance item with new values
      firestoreService.updateHistory(
        widget.maintenanceItem.id,
        descriptionController.text,
        int.parse(mileageController.text),
        _selectedDate,
        _status == 'Completed',
      );
    }

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Maintenance updated successfully')),
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
          // const CurvedBackgroundDecoration(),
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
                    child: Column(children: [
                      buildTextField(
                        label: 'Maintenance Type',
                        hintText: 'Current mileage',
                        controller: mileageController,
                        enabled: _isEditing,
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
                            onTap: _isEditing
                                ? () async {
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
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryText,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: AppColors.borderSide),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate.toString().split(' ')[0],
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
                        onChanged: _isEditing
                            ? (value) {
                                setState(() {
                                  _status = value!;
                                });
                              }
                            : null,
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
                              enabled: _isEditing,
                              decoration: InputDecoration.collapsed(
                                hintText: '',
                              ),
                              style: textStyleWhite,
                            ),
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
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
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
