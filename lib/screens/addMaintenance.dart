import 'package:flutter/material.dart';
import '../Back-end/firestore_service.dart';
import '../constants/app_colors.dart';
import '../models/MaintID.dart';
import '../notifications/notification.dart';
import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';

class AddMaintenance extends StatefulWidget {
  const AddMaintenance({super.key});

  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

final TextEditingController maintenanceController = TextEditingController();
late FirestoreService firestoreService;

class _AddMaintenanceState extends State<AddMaintenance> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
      body: Stack(
        children: [
          CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(children: [
                SizedBox(height: 70),
                Text(
                  "Add Maintenance",
                  style: textStyleWhite.copyWith(fontSize: 22,fontWeight: FontWeight.w600),
                ),
                buildTextField(
                  hintText: 'Maintenance Type',
                  controller: typeController,
                ),
                const SizedBox(height: 20),

                // Date Picker
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
                              : 'Maintenance Date',
                          style: textStyleGray,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: 345,
                      height: 293.38,
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

                const SizedBox(height: 30),
                buildButton(
                  'Add Maintenance',
                  AppColors.buttonColor,
                  AppColors.buttonText,
                  onPressed: () {
                    NotiService().showNotification(
                      title: 'Maintenance Added!',
                      body: descriptionController.text,
                    );
                    firestoreService
                        .addMaintenanceList(descriptionController.text);
                  },
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
