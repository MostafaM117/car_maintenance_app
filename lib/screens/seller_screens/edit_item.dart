import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/ProductItemModel.dart';
import '../../models/car_data.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/seller_image-picker.dart';

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
  String? uploadedImageUrl;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ImagePickerContainer(
                onImageUploaded: (String url) {
                  setState(() {
                    uploadedImageUrl = url;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Product Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Name',
                    style: textStyleWhite.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w500),
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
                        hintText: 'Add Product Name',
                        hintStyle:
                            textStyleGray.copyWith(fontWeight: FontWeight.w400),
                      ),
                      style: textStyleGray,
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
                  Text('Description',
                      style: textStyleWhite.copyWith(fontSize: 16)),
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
                      decoration: InputDecoration.collapsed(hintText: ''),
                      style: textStyleWhite,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Car Make Dropdown
              buildDropdownField(
                label: 'Car Make',
                value: _selectedMake,
                options: _carMakes,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMake = newValue;
                    _selectedModel = null;
                    checkFormCompletion();
                  });
                },
              ),

              const SizedBox(height: 15),

              // Car Model Dropdown
              buildDropdownField(
                label: 'Car Model',
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
              ),

              const SizedBox(height: 15),

              // Product Category Dropdown
              buildDropdownField(
                label: 'Product Category',
                value: _selectedCategory,
                options: categories,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),

              const SizedBox(height: 15),

              // Availability Dropdown
              buildDropdownField(
                label: 'Availability',
                value: _selectedAvailability,
                options: availability,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAvailability = newValue;
                  });
                },
              ),

              // const SizedBox(height: 15),

              // // Stock Count
              // buildTextField(
              //   label: 'Stock Count',
              //   hintText: 'Add Count',
              //   controller: stockCountController,
              // ),

              const SizedBox(height: 15),

              // Price
              buildTextField(
                label: 'Price',
                hintText: 'Add Price',
                controller: priceController,
              ),

              const SizedBox(height: 25),

              buildTextField(
                label: 'Store Location',
                hintText: 'Add Store Location',
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  popUpBotton(
                    'Discard',
                    AppColors.primaryText,
                    AppColors.buttonText,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  popUpBotton(
                    'Save',
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
                        uploadedImageUrl ?? widget.item.imageUrl,
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
