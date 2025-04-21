import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/car_service.dart';
import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/mycar_Card.dart';
import 'formscreens/formscreen1.dart';
import '../forms/carform.dart' as car_form;

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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit ${car['make']} ${car['model']}'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 10),

                      // Avg usage
                      buildTextField(
                        label: 'Average monthly usage (KM)',
                        controller: avgKmController,
                        hintText: 'Average (KM)',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter average usage';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await FirebaseFirestore.instance
                                  .collection('cars')
                                  .doc(car['id'])
                                  .update({
                                'mileage':
                                    double.parse(mileageController.text.trim()),
                                'avgKmPerMonth':
                                    double.parse(avgKmController.text.trim()),
                                'lastUpdated': FieldValue.serverTimestamp(),
                              });

                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Car updated successfully')),
                              );
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error updating car: $e')),
                              );
                            }
                          }
                        },
                        child: Text('Update'),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Text(
                    "My Cars",
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
                              child: Text(
                                  'No cars found. Add a car to see it here.'));
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

                            return CarCard(
                              // context: context,
                              carName: '${car['make']} ${car['model']}',
                              carId: car['id'],
                              odometer: '$mileage KM',
                              year: car['year'] as int? ?? 0,
                              mileage: mileage,
                              avgKmPerMonth: avgKmPerMonth,
                              onCardPressed: () {
                                _showEditForm(context, car);
                              },
                              onDeletePressed: () async {
                                // Show confirmation dialog
                                bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Car'),
                                          content: Text(
                                              'Are you sure you want to delete this car?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false;

                                if (confirmDelete) {
                                  try {
                                    await CarService.deleteCar(car['id']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Car deleted successfully')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Error deleting car: $e')),
                                    );
                                  }
                                }
                              },
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
