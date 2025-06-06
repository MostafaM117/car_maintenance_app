import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/screens/addMaintenance.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/car_data.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/seller_image-picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? _selectedMake;
  String? _selectedModel;
  final TextEditingController descriptionController = TextEditingController();
  final List<String> categories = ['Used', 'New'];
  String? _selectedCategory;
  final List<String> availability = ['In Stock', 'Out of Stock'];
  String? _selectedAvailability;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController stockCountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? uploadedImageUrl;

  final List<String> _carMakes = CarData.getAllMakes();
  @override
  void initState() {
    super.initState();
    firestoreService =
        FirestoreService(MaintID()); // Initialize the firestoreService variable
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
              //item name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Name',
                      style: textStyleWhite.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  Container(
                    height: 45,
                    decoration: ShapeDecoration(
                      color: AppColors.secondaryText,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: AppColors.borderSide,
                        ),
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

              SizedBox(
                height: 15,
              ), // Description Field
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
                        side: BorderSide(
                          width: 1,
                          color: AppColors.borderSide,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: TextField(
                        controller: descriptionController,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration.collapsed(
                          hintText: '',
                        ),
                        style: textStyleWhite),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              // Car Make
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

              // Car Model
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
              buildDropdownField(
                label: 'Product Category',
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                options: categories,
              ),
              SizedBox(
                height: 15,
              ),
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
              // SizedBox(
              //   height: 15,
              // ),
              // buildTextField(
              //     label: 'Stock Count',
              //     hintText: 'Add Count',
              //     controller: stockCountController),
              SizedBox(
                height: 15,
              ),
              //item price
              buildTextField(
                label: 'Price',
                hintText: 'Add Price',
                controller: priceController,
              ),
              // SizedBox(
              //   height: 25,
              // ),

              // buildTextField(
              //   label: 'Store Location',
              //   hintText: 'Add Store Location',
              // ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  popUpBotton(
                    'Discard',
                    AppColors.primaryText,
                    AppColors.buttonText,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                  popUpBotton(
                    'Add',
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () {
                      firestoreService.addProduct(
                        itemNameController.text,
                        descriptionController.text,
                        _selectedMake!,
                        _selectedModel!,
                        _selectedCategory!,
                        _selectedAvailability!,
                        priceController.text.isEmpty
                            ? 0.0
                            : double.parse(priceController.text),
                        uploadedImageUrl!,
                      );
                      Navigator.pop(context, itemNameController.text);
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
