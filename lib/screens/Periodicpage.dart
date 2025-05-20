import 'package:animations/animations.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/ProductItemModel.dart';
import 'package:car_maintenance/models/car_data.dart';
import 'package:car_maintenance/screens/ProductDetailsPage.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/ProductCard.dart';

class Periodicpage extends StatefulWidget {
  Periodicpage({
    super.key,
  });

  @override
  State<Periodicpage> createState() => _PeriodicpageState();
}

class _PeriodicpageState extends State<Periodicpage> {
  FirestoreService firestoreService = FirestoreService(MaintID());
  String? filterMake;
  String? filterModel;
  double? minPrice;
  double? maxPrice;
  String? selectedLocation;
  final List<String> _carMakes = CarData.getAllMakes();

  void checkFormCompletion() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    firestoreService =
        FirestoreService(MaintID()); // Initialize the firestoreService variable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Periodic",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppColors.borderSide,
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: TextField(
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton('Filters'),
                            // const SizedBox(width: 8),
                            // _buildFilterButton('Location'),
                            // const SizedBox(width: 8),
                            // _buildFilterButton('Make'),
                            // const SizedBox(width: 8),
                            // _buildFilterButton('Model'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<List<ProductItem>>(
                        stream: firestoreService.getFilteredProducts(
                          make: filterMake,
                          model: filterModel,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          location: selectedLocation,
                        ),
                        builder: (context, snapshot) {
                          final products = snapshot.data ?? [];
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 0.80),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return OpenContainer(
                                transitionType:
                                    ContainerTransitionType.fadeThrough,
                                transitionDuration: Duration(milliseconds: 500),
                                closedElevation: 0,
                                closedColor: Colors.transparent,
                                openColor: Colors.white,
                                closedBuilder: (context, openContainer) {
                                  return GestureDetector(
                                    onTap: openContainer,
                                    child: ProductCard(
                                      image: 'assets/images/motor_oil.png',
                                      title: product.name,
                                      price: product.price.toString(),
                                    ),
                                  );
                                },
                                openBuilder: (context, _) {
                                  return ProductDetailsPage(
                                    image: 'assets/images/motor_oil.png',
                                    title: product.name,
                                    price: product.price.toString(),
                                    description: product.description,
                                  );
                                },
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Filter'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add your filter options here
                    // Car Make
                    buildDropdownField(
                      label: 'Car Make',
                      value: filterMake,
                      options: _carMakes,
                      onChanged: (String? newValue) {
                        setState(() {
                          filterMake = newValue;
                          filterModel = null;
                          checkFormCompletion();
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // Car Model
                    buildDropdownField(
                      label: 'Car Model',
                      value: filterModel,
                      options: filterMake == null
                          ? []
                          : CarData.getModelsForMake(filterMake),
                      onChanged: (String? newValue) {
                        setState(() {
                          filterModel = newValue;
                          checkFormCompletion();
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Min Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          minPrice = double.tryParse(value);
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Max Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          maxPrice = double.tryParse(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Apply'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterMake = null;
                      filterModel = null;
                      minPrice = null;
                      maxPrice = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Reset'),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(title),
    );
  }
}
