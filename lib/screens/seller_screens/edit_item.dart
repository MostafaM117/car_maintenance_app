import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/app_colors.dart';
import '../../models/ProductItemModel.dart';
import '../../models/car_data.dart';
import '../../widgets/custom_widgets.dart' as custom;

class EditItem extends StatefulWidget {
  final ProductItem item;

  const EditItem({Key? key, required this.item}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController itemNameController;
  late TextEditingController descriptionController;
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedCategory;
  String? _selectedAvailability;
  late TextEditingController stockCountController;
  late TextEditingController priceController;

  final List<String> categories = ['Periodic', 'Used', 'Unused'];
  final List<String> availability = ['Available', 'Not Available'];

  final List<String> _carMakes = CarData.getAllMakes();

  late FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();

    itemNameController = TextEditingController(text: widget.item.name);
    descriptionController =
        TextEditingController(text: widget.item.description);
    _selectedMake = widget.item.selectedMake;
    _selectedModel = widget.item.selectedModel;
    _selectedCategory = widget.item.selectedCategory;
    _selectedAvailability = widget.item.selectedAvailability;

    stockCountController =
        TextEditingController(text: widget.item.stockCount.toString());
    priceController = TextEditingController(text: widget.item.price.toString());

    firestoreService = FirestoreService(MaintID());
  }

  void checkFormCompletion() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const custom.ImagePickerContainer(),

              const SizedBox(height: 15),

              // Product Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.productNameLabel,
                    style: custom.textStyleWhite
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 45,
                    decoration: ShapeDecoration(
                      color: AppColors.secondaryText,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: AppColors.borderSide),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: itemNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: l10n.addProductHint,
                        hintStyle: custom.textStyleGray
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      style: custom.textStyleGray,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.descriptionLabel,
                      style: custom.textStyleWhite.copyWith(fontSize: 16)),
                  Container(
                    width: 350,
                    height: 133.79,
                    padding: EdgeInsets.all(9),
                    decoration: ShapeDecoration(
                      color: AppColors.secondaryText,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: AppColors.borderSide),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration.collapsed(
                          hintText: l10n.descriptionHint),
                      style: custom.textStyleWhite,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Car Make Dropdown
              custom.buildDropdownField(
                label: l10n.carMakeLabel,
                value: _selectedMake,
                options: _carMakes,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMake = newValue;
                    _selectedModel = null;
                    checkFormCompletion();
                  });
                },
                context: context,
              ),

              const SizedBox(height: 15),

              // Car Model Dropdown
              custom.buildDropdownField(
                label: l10n.carModelLabel,
                value: _selectedModel,
                options: _selectedMake == null
                    ? []
                    : CarData.getModelsForMake(_selectedMake),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModel = newValue;
                    checkFormCompletion();
                  });
                },
                context: context,
              ),

              const SizedBox(height: 15),

              // Product Category Dropdown
              custom.buildDropdownField(
                label: l10n.productCategoryLabel,
                value: _selectedCategory,
                options: categories,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                context: context,
              ),

              const SizedBox(height: 15),

              // Availability Dropdown
              custom.buildDropdownField(
                label: l10n.availabilityLabel,
                value: _selectedAvailability,
                options: availability,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAvailability = newValue;
                  });
                },
                context: context,
              ),

              const SizedBox(height: 15),

              // Stock Count
              custom.buildTextField(
                label: l10n.stockCountLabel,
                hintText: l10n.addCountHint,
                controller: stockCountController,
              ),

              const SizedBox(height: 15),

              // Price
              custom.buildTextField(
                label: l10n.priceLabel,
                hintText: l10n.addPriceHint,
                controller: priceController,
              ),

              const SizedBox(height: 25),

              custom.buildTextField(
                label: l10n.storeLocationLabel,
                hintText: l10n.addStoreLocationHint,
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  custom.popUpBotton(
                    l10n.discardButton,
                    AppColors.primaryText,
                    AppColors.buttonText,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  custom.popUpBotton(
                    l10n.save,
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () {
                      firestoreService.updateProduct(
                        widget.item.id, // لازم يكون عندك id في item model
                        itemNameController.text,
                        descriptionController.text,
                        _selectedMake!,
                        _selectedModel!,
                        _selectedCategory!,
                        _selectedAvailability!,
                        int.tryParse(stockCountController.text) ?? 0,
                        double.tryParse(priceController.text) ?? 0.0,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
