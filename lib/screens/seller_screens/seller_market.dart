import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/ProductItemModel.dart';
import 'package:car_maintenance/models/car_data.dart';
// import 'package:car_maintenance/screens/Periodicpage.dart';
import 'package:car_maintenance/screens/seller_screens/add_item.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? selectedLocation;
  final List<String> _carMakes = CarData.getAllMakes();

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
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.sellerMarketTitle,
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
                            hintText: l10n.searchHint,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            suffixIcon: Icon(Icons.search_rounded)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildFilterButton(l10n.filtersButton),
                ],
              ),
              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     _buildFilterButton('Filters'),

              //     // const SizedBox(width: 8),
              //     // _buildFilterButton('Filter'),
              //   ],
              // ),
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
                    children: [
                      Text(
                        l10n.addNewItemButton,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/add.svg',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // Items List
              Expanded(
                child: StreamBuilder<List<ProductItem>>(
                    stream: firestoreService.getStock(),
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
                                            l10n.confirmDeleteItemTitle,
                                            style: textStyleWhite,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            l10n.confirmDeleteItemBody,
                                            style: textStyleGray,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              popUpBotton(
                                                l10n.cancel,
                                                AppColors.primaryText,
                                                AppColors.buttonText,
                                                onPressed: () {
                                                  confirmDelete = false;
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              const SizedBox(width: 15),
                                              popUpBotton(
                                                l10n.delete,
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
    final l10n = AppLocalizations.of(context)!;
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
                      l10n.filter,
                      style: textStyleWhite.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    buildDropdownField(
                      label: l10n.carMakeLabel,
                      value: filterMake,
                      options: _carMakes,
                      onChanged: (String? newValue) {
                        setState(() {
                          filterMake = newValue;
                          filterModel = null;
                          checkFormCompletion();
                        });
                      },
                      context: context,
                    ),
                    const SizedBox(height: 15),
                    buildDropdownField(
                      label: l10n.carModelLabel,
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
                      context: context,
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      label: l10n.minPriceLabel,
                      validator: (value) {
                        setState(() {
                          minPrice = double.tryParse(value ?? '');
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: l10n.maxPriceLabel,
                      validator: (value) {
                        setState(() {
                          maxPrice = double.tryParse(value ?? '');
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        popUpBotton(
                          l10n.reset,
                          AppColors.primaryText,
                          AppColors.buttonText,
                          onPressed: () {
                            setState(() {
                              filterMake = null;
                              filterModel = null;
                              minPrice = null;
                              maxPrice = null;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 15),
                        popUpBotton(
                          l10n.apply,
                          AppColors.buttonColor,
                          AppColors.buttonText,
                          onPressed: () {
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
