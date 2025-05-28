import 'dart:io';

import 'package:car_maintenance/Back-end/offer_service.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/offer_model.dart';
import 'package:car_maintenance/widgets/custom_Form_Field.dart';
import 'package:car_maintenance/widgets/offer_img.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving offer')));
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
    final l10n = AppLocalizations.of(context)!;
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
              customFormField(
                controller: _titleController,
                label: l10n.title,
                hintText: l10n.add,
                validator: (v) => v == null || v.isEmpty ? l10n.required : null,
              ),
              customFormField(
                controller: _descriptionController,
                label: l10n.description,
                hintText: l10n.add,
                validator: (v) => v == null || v.isEmpty ? l10n.required : null,
              ),
              customFormField(
                controller: _originalPriceController,
                label: l10n.originalPrice,
                hintText: l10n.add,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.required;
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return l10n.invalidFormat;
                  return null;
                },
              ),
              customFormField(
                controller: _discountController,
                label: l10n.discount,
                hintText: l10n.add,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.required;
                  final n = double.tryParse(v);
                  if (n == null || n < 0 || n > 100) return l10n.invalidFormat;
                  return null;
                },
              ),
              OfferImg(
                onImageUploaded: (url) {
                  setState(() {
                    _selectedImage = url;
                  });
                },
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _validUntil == null
                          ? l10n.select
                          : '${l10n.validUntil}: ${_validUntil!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(color: AppColors.primaryText),
                    ),
                  ),
                  TextButton(onPressed: pickDate, child: Text(l10n.choose)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  popUpBotton(
                    l10n.cancel,
                    AppColors.primaryText,
                    AppColors.buttonText,
                    onPressed: () {
                      clearForm();
                      Navigator.of(context).pop();
                    },
                  ),
                  popUpBotton(
                    editingOfferId == null ? l10n.add : l10n.update,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          clearForm();
          showOfferFormDialog();
        },
        label: Text(l10n.add),
        icon: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.offers,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Offer>>(
                stream: offerService.getOffers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text(l10n.error);
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final offers = snapshot.data!;
                  if (offers.isEmpty) return Text(l10n.noData);

                  return ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (offer.imageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/offer.jpg',
                                    image: offer.imageUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Image.asset(
                                        'assets/images/offer.jpg',
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 8),
                              Text(
                                offer.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(offer.description),
                              SizedBox(height: 6),
                              Text('${l10n.seller}: ${offer.business_name}'),
                              Text(
                                '${l10n.originalPrice}: \$${offer.originalPrice.toStringAsFixed(2)}',
                              ),
                              Text(
                                '${l10n.discount}: ${offer.discountPercentage}%',
                              ),
                              Text(
                                '${l10n.priceAfterDiscount}: \$${offer.priceAfterDiscount.toStringAsFixed(2)}',
                              ),
                              Text(
                                '${l10n.validUntil}: ${offer.validUntil.toLocal().toString().split(' ')[0]}',
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => startEditing(offer),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteOffer(offer.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
