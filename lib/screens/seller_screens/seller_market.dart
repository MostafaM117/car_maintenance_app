import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/Back-end/offer_service.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/ProductItemModel.dart';
import 'package:car_maintenance/models/car_data.dart';
import 'package:car_maintenance/screens/Periodicpage.dart';
import 'package:car_maintenance/screens/seller_screens/add_item.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'edit_item.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<String> items = [];
  final TextEditingController _searchController = TextEditingController();
  FirestoreService firestoreService = FirestoreService(MaintID());
  String? filterMake;
  String? filterModel;
  double? minPrice;
  double? maxPrice;
  String? searchQuery;
  final OfferService offerService = OfferService();
  String? businessName;
  final List<String> _carMakes = CarData.getAllMakes();

  void getMyBusinessName() async {
    businessName = await offerService.getBusinessName();
    setState(() {});
  }

  @override
  void initState() {
    getMyBusinessName();
    super.initState();
  }

  void checkFormCompletion() {
    setState(() {});
  }

  void _editItem(ProductItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItem(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Market',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // ← هذا يملأ المساحة المتاحة
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
              const SizedBox(height: 20),
              // Input for new item
              GestureDetector(
                onTap: () async {
                  final newItemName = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddItem(),
                    ),
                  );

                  if (newItemName != null) {
                    setState(() {
                      items.add(newItemName);
                    });
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Add New Item',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(Icons.add, size: 30, color: Colors.black),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Items List
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
                      businessName: businessName,
                    ),
                    builder: (context, snapshot) {
                      final productList = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          final product = productList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryText,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/svg/edit.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () => _editItem(product),
                                ),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/svg/delete.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () async {
                                    bool confirmDelete = false;

                                    await AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.scale,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      dialogBackgroundColor:
                                          AppColors.borderSide,
                                      dismissOnTouchOutside: true,
                                      body: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Are you sure you want to delete this Item?',
                                            style: textStyleWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'This action is permanent and cannot be undone. All Item’s data will be permanently removed.',
                                            style: textStyleGray,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              popUpBotton(
                                                'Cancel',
                                                AppColors.primaryText,
                                                AppColors.buttonText,
                                                onPressed: () {
                                                  confirmDelete = false;
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              const SizedBox(width: 15),
                                              popUpBotton(
                                                'Delete',
                                                AppColors.buttonColor,
                                                AppColors.buttonText,
                                                onPressed: () {
                                                  firestoreService
                                                      .deleteProduct(
                                                          product.id);
                                                  confirmDelete = true;
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ).show();

                                    if (confirmDelete) {
                                      setState(() {
                                        items.removeAt(index);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
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
                          minPrice = double.tryParse(value);
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Max Price',
                      validator: (value) {
                        setState(() {
                          maxPrice = double.tryParse(value);
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
