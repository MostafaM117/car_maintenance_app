import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/mileage_service.dart';
import 'custom_widgets.dart';

/// A widget that displays and allows editing of a car's mileage
class MileageDisplay extends StatefulWidget {
  final String carId;
  final dynamic currentMileage;
  final dynamic avgKmPerMonth;
  final Function(int)? onMileageUpdated;

  const MileageDisplay({
    Key? key,
    required this.carId,
    required this.currentMileage,
    required this.avgKmPerMonth,
    this.onMileageUpdated,
  }) : super(key: key);

  static void showMileageEditDialog(
    BuildContext context,
    String carId,
    int currentMileage, {
    Function(int)? onMileageUpdated,
  }) {
    final editController =
        TextEditingController(text: currentMileage.toString());

    AwesomeDialog(
      dialogBackgroundColor: AppColors.secondaryText,
      context: context,
      dialogType: DialogType.noHeader,
      dialogBorderRadius: BorderRadius.circular(15),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: true,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Mileage.',
              style: TextStyle(
                color: Color(0xFF2E2E2E),
                fontSize: 24,
                fontFamily: 'Inter',
                height: 0,
              ),
            ),
            SizedBox(height: 3),

            Text(
              "Need to change more details? Head over to the 'My Cars' screen to manage your Car.",
              style: TextStyle(
                color: Colors.black.withOpacity(0.699999988079071),
                fontSize: 16,
                fontFamily: 'Inter',
                height: 0,
              ),
            ),
            SizedBox(height: 16),
            // TextField(
            //   controller: editController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'Mileage',
            //     suffixText: 'km',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   autofocus: true,
            // ),
            buildTextField(
              label: 'Current car mileage (Approx.)',
              controller: editController,
              hintText: 'Mileage (KM)',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter mileage';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Cancel'),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(250, 45),
                  ),
                  onPressed: () async {
                    try {
                      final newMileage = int.parse(editController.text);

                      await FirebaseFirestore.instance
                          .collection('cars')
                          .doc(carId)
                          .update({
                        'mileage': newMileage,
                        'lastUpdated': FieldValue.serverTimestamp(),
                      });

                      onMileageUpdated?.call(newMileage);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Mileage updated successfully to $newMileage km'),
                        ),
                      );

                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update mileage: $e'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Save',
                    style: textStyleWhite.copyWith(
                      fontSize: 18,
                      color: AppColors.buttonColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryText,
                    elevation: 0,
                    side: BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(250, 45),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: textStyleWhite.copyWith(
                      fontSize: 18,
                      color: AppColors.buttonText,
                    ),
                  ),
                ),
                // SizedBox(width: 12),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.red,
                //     foregroundColor: Colors.white,
                //   ),
                //   onPressed: () async {
                //     try {
                //       final newMileage = int.parse(editController.text);

                //       await FirebaseFirestore.instance
                //           .collection('cars')
                //           .doc(carId)
                //           .update({
                //         'mileage': newMileage,
                //         'lastUpdated': FieldValue.serverTimestamp(),
                //       });

                //       onMileageUpdated?.call(newMileage);

                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //           content: Text(
                //               'Mileage updated successfully to $newMileage km'),
                //         ),
                //       );

                //       Navigator.of(context).pop();
                //     } catch (e) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //           content: Text('Failed to update mileage: $e'),
                //         ),
                //       );
                //     }
                //   },
                //   child: Text('Save'),
                // ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }

  @override
  State<MileageDisplay> createState() => _MileageDisplayState();
}

class _MileageDisplayState extends State<MileageDisplay> {
  final MileageService _mileageService = MileageService();
  late TextEditingController _controller;
  int _displayMileage = 0;

  @override
  void initState() {
    super.initState();
    _loadMileage();
  }

  @override
  void didUpdateWidget(MileageDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.carId != widget.carId ||
        oldWidget.currentMileage != widget.currentMileage) {
      _loadMileage();
    }
  }

  Future<void> _loadMileage() async {
    try {
      final carDoc = await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carId)
          .get();

      int mileage;
      if (carDoc.exists) {
        final carData = carDoc.data()!;
        mileage = carData['mileage'] is double
            ? (carData['mileage'] as double).toInt()
            : carData['mileage'] as int? ?? 0;
      } else {
        mileage = widget.currentMileage is double
            ? (widget.currentMileage as double).toInt()
            : widget.currentMileage as int? ?? 0;
      }

      setState(() {
        _displayMileage = mileage;
        _controller = TextEditingController(text: mileage.toString());
      });
    } catch (e) {
      print('MILEAGE DEBUG: Error loading mileage for car ${widget.carId}: $e');

      final mileage = widget.currentMileage is double
          ? (widget.currentMileage as double).toInt()
          : widget.currentMileage as int? ?? 0;

      setState(() {
        _displayMileage = mileage;
        _controller = TextEditingController(text: mileage.toString());
      });
    }

    if (widget.avgKmPerMonth != null && widget.avgKmPerMonth > 0) {
      try {
        final updatedMileage =
            await _mileageService.autoUpdateMileage(widget.carId);
        if (updatedMileage != _displayMileage) {
          setState(() {
            _displayMileage = updatedMileage;
            _controller.text = updatedMileage.toString();
          });
          widget.onMileageUpdated?.call(updatedMileage);
        }
      } catch (e) {
        print(
            'MILEAGE DEBUG: Error auto-updating mileage for car ${widget.carId}: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        MileageDisplay.showMileageEditDialog(
          context,
          widget.carId,
          _displayMileage,
          onMileageUpdated: (newMileage) {
            if (mounted) {
              setState(() {
                _displayMileage = newMileage;
              });
              widget.onMileageUpdated?.call(newMileage);
            }
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mileage: ',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '$_displayMileage km',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.edit, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}
