import 'package:car_maintenance/Back-end/offer_service.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/offer_model.dart';
import 'package:car_maintenance/widgets/custom_Form_Field.dart';
import 'package:car_maintenance/widgets/offer_img.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/offercard.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final OfferService offerService = OfferService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String? _selectedImage;
  DateTime? _validUntil;
  String? editingOfferId;
  late String business_name;
  late String phoneNumber;
  late double longitude;
  late double latitude;
  void getMyBusinessInfo() async {
    business_name = await offerService.getBusinessName();
    phoneNumber = await offerService.getPhoneNumber();
    longitude = await offerService.getLongitude();
    latitude = await offerService.getLatitude();
    setState(() {});
    print('Business Name: $business_name');
    print('Phone Number: $phoneNumber');
    print('Longitude: $longitude');
    print('Latitude: $latitude');
  }

  @override
  void initState() {
    super.initState();
    getMyBusinessInfo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> saveOffer() async {
    if (!_formKey.currentState!.validate() || _validUntil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    final business_name = await offerService.getBusinessName();
    if (business_name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not fetch business name')),
      );
      return;
    }

    final originalPrice = double.parse(_originalPriceController.text.trim());
    final discount = double.parse(_discountController.text.trim());
    final discountedPrice = originalPrice - (originalPrice * discount / 100);

    final offer = Offer(
      id: editingOfferId ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      originalPrice: originalPrice,
      discountPercentage: discount,
      priceAfterDiscount: discountedPrice,
      validUntil: _validUntil!,
      business_name: business_name,
      imageUrl: _selectedImage ?? '',
      // phoneNumber: phoneNumber,
      // longitude: longitude,
      // latitude: latitude,
    );

    try {
      if (editingOfferId == null) {
        await offerService.addOffer(offer);
      } else {
        await offerService.updateOffer(offer);
      }
      clearForm();
    } catch (e) {
      print('❌ Error saving offer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving offer')),
      );
    }
  }

  Future<void> clearForm() async {
    _titleController.clear();
    _descriptionController.clear();
    _originalPriceController.clear();
    _discountController.clear();
    _validUntil = null;
    editingOfferId = null;
    _selectedImage = null;
    setState(() {});
  }

  void startEditing(Offer offer) {
    _titleController.text = offer.title;
    _descriptionController.text = offer.description;
    _originalPriceController.text = offer.originalPrice.toString();
    _discountController.text = offer.discountPercentage.toString();
    _validUntil = offer.validUntil;
    editingOfferId = offer.id;
    showOfferFormDialog();
  }

  Future<void> deleteOffer(String id) async {
    await offerService.deleteOffer(id);
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntil ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _validUntil = picked;
      });
    }
  }

  void showOfferFormDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      dialogBackgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OfferImg(
                onImageUploaded: (url) {
                  setState(() {
                    _selectedImage = url;
                  });
                },
              ),
              customFormField(
                controller: _titleController,
                label: 'Title',
                hintText: 'Add Title',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a title' : null,
              ),
              customFormField(
                controller: _descriptionController,
                label: 'Description',
                hintText: 'Add Description',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a description' : null,
              ),
              customFormField(
                controller: _originalPriceController,
                label: 'Original Price',
                hintText: 'Add price',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter original price';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Enter a valid price';
                  return null;
                },
              ),
              customFormField(
                controller: _discountController,
                label: 'Discount %',
                hintText: 'Enter discount',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter discount';
                  final n = double.tryParse(v);
                  if (n == null || n < 0 || n > 100) return 'Enter 0-100%';
                  return null;
                },
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _validUntil == null
                          ? 'Select valid until date'
                          : 'Valid Until: ${_validUntil!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(color: AppColors.primaryText),
                    ),
                  ),
                  TextButton(
                    onPressed: pickDate,
                    child: Text('Pick Date'),
                  )
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  popUpBotton(
                    'Discard',
                    AppColors.primaryText,
                    AppColors.buttonText,
                    onPressed: () {
                      clearForm();
                      Navigator.of(context).pop();
                    },
                  ),
                  popUpBotton(
                    editingOfferId == null ? 'Add' : 'Update',
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () async {
                      await saveOffer();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Offers",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Offer>>(
                stream: offerService.getOffersByBusinessName(business_name),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('Error loading offers');
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final offers = snapshot.data!;
                  if (offers.isEmpty) {
                    return Center(child: Text('No offers Posted yet.', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],),));
                  }

                  return ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];

                      return OfferCard(
                        title: offer.title,
                        date:
                            'Valid Until: ${offer.validUntil.toLocal().toString().split(' ')[0]}',
                        imageUrl:
                            offer.imageUrl.isNotEmpty ? offer.imageUrl : null,
                        onEdit: () => startEditing(offer),
                        onDelete: () => deleteOffer(offer.id),
                      );
                    },
                  );
                },
              ),
            ),
            // SizedBox(height: 16),
            buildButton(
              'Add Offer',
              AppColors.buttonColor,
              AppColors.buttonText,
              onPressed: () {
                clearForm();
                showOfferFormDialog();
              },
            ),
            SizedBox(height: 51),
          ],
        ),
      ),
    );
  }
}
