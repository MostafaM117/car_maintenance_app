import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance/models/offer_model.dart'; // Adjust the import path as necessary
import 'package:firebase_auth/firebase_auth.dart';

class OfferService {
  final CollectionReference offersCollection =
      FirebaseFirestore.instance.collection('offers');
  final CollectionReference sellersCollection =
      FirebaseFirestore.instance.collection('sellers');
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Gets the current seller's business name from Firestore
  Future<String> getBusinessName() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) return '';

      final doc = await sellersCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['businessname'] ?? '';
      } else {
        print('❌ Seller document not found');
        return '';
      }
    } catch (e) {
      print('❌ Error fetching businessname: $e');
      return '';
    }
  }

  /// Adds a new offer to Firestore
  Future<bool> addOffer(Offer offer) async {
    try {
      await offersCollection.add(offer.toFirestore());
      print("✅ Added offer item");
      return true;
    } catch (e) {
      print("❌ Error adding offer item: $e");
      return false;
    }
  }

  /// Retrieves a stream of all offers
  Stream<List<Offer>> getOffers() {
    return offersCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList());
  }

  /// Updates an existing offer in Firestore
  Future<bool> updateOffer(Offer offer) async {
    try {
      await offersCollection.doc(offer.id).update(offer.toFirestore());
      print("✅ Updated offer item with ID: ${offer.id}");
      return true;
    } catch (e) {
      print("❌ Error updating offer item: $e");
      return false;
    }
  }

  /// Deletes an offer from Firestore
  Future<bool> deleteOffer(String docId) async {
    try {
      await offersCollection.doc(docId).delete();
      print("✅ Deleted offer with ID: $docId");
      return true;
    } catch (e) {
      print("❌ Error deleting offer item: $e");
      return false;
    }
  }

  /// (Optional) Get offers filtered by seller ID (businessname)
  Stream<List<Offer>> getOffersByBusinessName(String businessname) {
    return offersCollection
        .where('businessname', isEqualTo: businessname)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList());
  }
}
