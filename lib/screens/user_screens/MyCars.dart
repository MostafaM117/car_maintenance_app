import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/car_service.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/mycar_Card.dart';
import '../formscreens/formscreen1.dart';
import '../../models/MaintID.dart';
import '../../Back-end/firestore_service.dart';

class CarMaint extends StatefulWidget {
  const CarMaint({super.key});

  @override
  State<CarMaint> createState() => _CarMaintState();
}

class _CarMaintState extends State<CarMaint> {
  // Function to show the edit form dialog

  void _showEditForm(BuildContext context, Map<String, dynamic> car) {
    final TextEditingController mileageController = TextEditingController(
        text: (car['mileage'] is double
                ? car['mileage'].toInt()
                : car['mileage'] as int? ?? 0)
            .toString());
    final TextEditingController avgKmController = TextEditingController(
        text: (car['avgKmPerMonth'] is double
                ? car['avgKmPerMonth'].toInt()
                : car['avgKmPerMonth'] as int? ?? 0)
            .toString());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isLoading = false;

    AwesomeDialog(
      padding: EdgeInsets.all(12),
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Edit ${car['make']} ${car['model']} Details',
                  style: textStyleWhite.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 15),
                buildTextField(
                  label: S.of(context).current_car_mileage,
                  controller: mileageController,
                  hintText: S.of(context).mileage_hint,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).please_enter_mileage;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                buildTextField(
                  label: S.of(context).average_monthly_usage_km,
                  controller: avgKmController,
                  hintText: S.of(context).average_km,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return S.of(context).please_enter_average_usage;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          popUpBotton(
                            S.of(context).cancel,
                            AppColors.primaryText,
                            AppColors.buttonText,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          popUpBotton(
                            S.of(context).save,
                            AppColors.buttonColor,
                            AppColors.buttonText,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);

                                try {
                                  final int newMileage = double.parse(
                                          mileageController.text.trim())
                                      .toInt();
                                  final int newAvgKm =
                                      double.parse(avgKmController.text.trim())
                                          .toInt();

                                  await FirebaseFirestore.instance
                                      .collection('cars')
                                      .doc(car['id'])
                                      .update({
                                    'mileage': newMileage,
                                    'avgKmPerMonth': newAvgKm,
                                    'lastUpdated': FieldValue.serverTimestamp(),
                                  });

                                  final updatedMileage = newMileage;

                                  final make = car['make'].toString();
                                  final model = car['model'].toString();
                                  final year = car['year'].toString();

                                  final maintID = MaintID()
                                    ..selectedMake = make
                                    ..selectedModel = model
                                    ..selectedYear = year;

                                  final firestoreService =
                                      FirestoreService(maintID);

                                  firestoreService
                                      .getMaintenanceList()
                                      .first
                                      .then((maintList) {
                                    for (final item in List.from(maintList)) {
                                      if (updatedMileage >= item.mileage &&
                                          !item.isDone) {
                                        firestoreService.moveToHistory(item.id);
                                      }
                                    }
                                  });

                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Car updated successfully'),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() => isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error updating car: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
      dialogBackgroundColor: AppColors.secondaryText,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Text(
                    S.of(context).my_cars,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),

                  // Stream builder to display all user cars
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CarService.getUserCarsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(S.of(context).no_cars_found),
                          );
                        }

                        // Convert documents to List of Maps
                        List<Map<String, dynamic>> cars = [];
                        for (var doc in snapshot.data!.docs) {
                          Map<String, dynamic> car =
                              doc.data() as Map<String, dynamic>;
                          car['id'] = doc.id;
                          cars.add(car);
                        }

                        return ListView.builder(
                          itemCount: cars.length,
                          itemBuilder: (context, index) {
                            final car = cars[index];
                            final int mileage = car['mileage'] is double
                                ? car['mileage'].toInt()
                                : car['mileage'] as int? ?? 0;
                            final int avgKmPerMonth =
                                car['avgKmPerMonth'] is double
                                    ? car['avgKmPerMonth'].toInt()
                                    : car['avgKmPerMonth'] as int? ?? 0;
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CarCard(
                                // context: context,
                                carName: '${car['make']} ${car['model']}',
                                carId: car['id'],
                                odometer: '$mileage KM',
                                year: car['year'] as int? ?? 0,
                                mileage: mileage,
                                avgKmPerMonth: avgKmPerMonth,
                                onEditPressed: () {
                                  _showEditForm(context, car);
                                },
                                onDeletePressed: () async {
                                  bool confirmDelete = false;

                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.noHeader,
                                    animType: AnimType.scale,
                                    dialogBackgroundColor:
                                        AppColors.secondaryText,
                                    body: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            S.of(context).confirm_delete_car,
                                            style: textStyleWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            S.of(context).delete_warning,
                                            style: textStyleGray,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 25),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              popUpBotton(
                                                S.of(context).cancel,
                                                AppColors.primaryText,
                                                AppColors.buttonText,
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // false
                                                },
                                              ),
                                              const SizedBox(width: 15),
                                              popUpBotton(
                                                S.of(context).delete,
                                                AppColors.buttonColor,
                                                AppColors.buttonText,
                                                onPressed: () {
                                                  confirmDelete = true;
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).show();

                                  if (confirmDelete) {
                                    try {
                                      await CarService.deleteCar(car['id']);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Car deleted successfully')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Error deleting car: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  buildButton(
                    S.of(context).add_new_car,
                    AppColors.buttonColor,
                    AppColors.secondaryText,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCarScreen()),
                      );
                    },
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
