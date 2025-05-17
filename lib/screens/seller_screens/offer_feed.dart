import 'package:car_maintenance/Back-end/offer_service.dart';
import 'package:car_maintenance/models/offer_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    final businessName = await offerService.getBusinessName();
    if (businessName.isEmpty) {
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
      businessname: businessName,
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
    setState(() {});
  }

  void startEditing(Offer offer) {
    _titleController.text = offer.title;
    _descriptionController.text = offer.description;
    _originalPriceController.text = offer.originalPrice.toString();
    _discountController.text = offer.discountPercentage.toString();
    _validUntil = offer.validUntil;
    editingOfferId = offer.id;
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offers Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter a title' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter a description' : null,
                  ),
                  TextFormField(
                    controller: _originalPriceController,
                    decoration: InputDecoration(labelText: 'Original Price'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter original price';
                      final n = double.tryParse(v);
                      if (n == null || n <= 0) return 'Enter a valid price';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _discountController,
                    decoration: InputDecoration(labelText: 'Discount %'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter discount';
                      final n = double.tryParse(v);
                      if (n == null || n < 0 || n > 100) return 'Enter 0-100%';
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Text(_validUntil == null
                          ? 'Select valid until date'
                          : 'Valid Until: ${_validUntil!.toLocal().toString().split(' ')[0]}'),
                      Spacer(),
                      TextButton(
                        onPressed: pickDate,
                        child: Text('Pick Date'),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: saveOffer,
                    child: Text(
                        editingOfferId == null ? 'Add Offer' : 'Update Offer'),
                  ),
                  if (editingOfferId != null)
                    TextButton(
                      onPressed: clearForm,
                      child: Text('Cancel'),
                    ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // List of offers
            Expanded(
              child: StreamBuilder<List<Offer>>(
                stream: offerService.getOffers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('Error loading offers');
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  final offers = snapshot.data!;
                  if (offers.isEmpty) return Text('No offers found.');

                  return ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(offer.title),
                          subtitle: Text('${offer.description}\n'
                              'Seller: ${offer.businessname}\n'
                              'Original Price: \$${offer.originalPrice}\n'
                              'Discount: ${offer.discountPercentage}%\n'
                              'Price After Discount: \$${offer.priceAfterDiscount}\n'
                              'Valid Until: ${offer.validUntil.toLocal().toString().split(' ')[0]}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => startEditing(offer),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteOffer(offer.id),
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
