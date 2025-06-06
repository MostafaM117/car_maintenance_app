import 'package:animations/animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/ProductItemModel.dart';
import 'package:car_maintenance/models/car_data.dart';
import 'package:car_maintenance/providers/locale_provider.dart';
import 'package:car_maintenance/screens/ProductDetailsPage.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../widgets/ProductCard.dart';

class Periodicpage extends StatefulWidget {
  final String title;

  const Periodicpage({super.key, required this.title});

  @override
  State<Periodicpage> createState() => _PeriodicpageState();
}

class _PeriodicpageState extends State<Periodicpage> {
  FirestoreService firestoreService = FirestoreService(MaintID());
  String? filterMake;
  String? filterModel;
  double? minPrice;
  double? maxPrice;
  String? searchQuery;
  final List<String> _carMakes = CarData.getAllMakes();
  final TextEditingController _searchController = TextEditingController();
  late bool isEnglish;
  String? _selectedCategory;

  void getArabicCategory() {
    final currentLang = context.read<LocaleProvider>().locale.languageCode;
    if (currentLang == 'ar') {
      if (widget.title == 'مستعمل') {
        _selectedCategory = 'Used';
      } else if (widget.title == 'جديد') {
        _selectedCategory = 'New';
      }
    } else {
      _selectedCategory = widget.title;
    }
    setState(() {
      _selectedCategory = _selectedCategory;
    });
  }

  void checkFormCompletion() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isEnglish = context.read<LocaleProvider>().locale.languageCode == 'en';
    getArabicCategory();
    firestoreService =
        FirestoreService(MaintID()); // Initialize the firestoreService variable
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        isEnglish = localeProvider.locale.languageCode == 'en';
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // const CurvedBackgroundDecoration(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          widget
                              .title, // use the the title value to filter products to used/new
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
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
                                controller: _searchController,
                                decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        setState(() {
                                          // Trigger search with current text
                                          searchQuery = _searchController.text;
                                        });
                                      },
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildFilterButton('Filters'),
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
                              searchQuery: _searchController.text.isNotEmpty
                                  ? _searchController.text
                                  : null,
                              selectedCategory:
                                  _selectedCategory, // use the title to filter products
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
                                    // opencontainers can't have null values, guess what my filter function requires
                                    transitionType:
                                        ContainerTransitionType.fadeThrough,
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    closedElevation: 0,
                                    closedColor: Colors.transparent,
                                    openColor: Colors.white,
                                    closedBuilder: (context, openContainer) {
                                      return GestureDetector(
                                        onTap: openContainer,
                                        child: ProductCard(
                                          image: product.imageUrl,
                                          title: product.name,
                                          price: product.price.toString(),
                                          businessName: product.businessName,
                                        ),
                                      );
                                    },
                                    openBuilder: (context, _) {
                                      return ProductDetailsPage(
                                        image: product.imageUrl,
                                        title: product.name,
                                        price: product.price.toString(),
                                        description: product.description,
                                        businessName: product.businessName,
                                        selectedAvailability:
                                            product.selectedAvailability,
                                        phoneNumber: product.phoneNumber,
                                        latitude: product.latitude,
                                        longitude: product.longitude,
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
      },
    );
  }

  Widget _buildFilterButton(String title) {
    return ElevatedButton(
      onPressed: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.scale,
          dialogBackgroundColor: AppColors.secondaryText,
          padding: const EdgeInsets.all(16),
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter',
                      style: textStyleWhite.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    buildTextField(
                      label: 'Min Price',
                      validator: (value) {
                        setState(() {
                          minPrice = double.tryParse(value ?? '');
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Max Price',
                      validator: (value) {
                        setState(() {
                          maxPrice = double.tryParse(value ?? '');
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        popUpBotton(
                          'Reset',
                          AppColors.primaryText,
                          AppColors.buttonText,
                          onPressed: () {
                            setState(() {
                              filterMake = null;
                              filterModel = null;
                              minPrice = null;
                              maxPrice = null;
                              _searchController.clear();
                              searchQuery = null;
                            });
                            checkFormCompletion();
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 15),
                        popUpBotton(
                          'Apply',
                          AppColors.buttonColor,
                          AppColors.buttonText,
                          onPressed: () {
                            checkFormCompletion();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ).show();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primaryText,
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
