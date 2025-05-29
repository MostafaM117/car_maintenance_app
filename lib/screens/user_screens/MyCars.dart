import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.editCarDetails(car['make'], car['model']),
                  style: textStyleWhite.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 15),
                buildTextField(
                  label: l10n.currentMileageLabel,
                  controller: mileageController,
                  hintText: l10n.mileageHint,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterMileageError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                buildTextField(
                  label: l10n.avgMonthlyUsageLabel,
                  controller: avgKmController,
                  hintText: l10n.avgKmHint,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterAvgUsageError;
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
                            l10n.cancel,
                            AppColors.primaryText,
                            AppColors.buttonText,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          popUpBotton(
                            l10n.save,
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
                                      content: Text(l10n.carUpdatedSuccess),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() => isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.errorUpdatingCar(e.toString())),
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
    final l10n = AppLocalizations.of(context)!;
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
                    l10n.myCars,
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
                              child: Text(l10n.dataError(snapshot.error.toString())));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text(l10n.noCarsFound));
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
                                            'Are you sure you want to delete your car?',
                                            style: textStyleWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            'This action is permanent and cannot be undone. All your data will be permanently removed.',
                                            style: textStyleGray,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 25),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              popUpBotton(
                                                'Cancel',
                                                AppColors.primaryText,
                                                AppColors.buttonText,
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // false
                                                },
                                              ),
                                              const SizedBox(width: 15),
                                              popUpBotton(
                                                'Delete',
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
                    'Add Car',
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
