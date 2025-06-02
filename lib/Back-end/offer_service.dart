import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance/models/offer_model.dart';
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
        return data['business_name'] ?? '';
      } else {
        print('❌ Seller document not found');
        return '';
      }
    } catch (e) {
      print('❌ Error fetching business_name: $e');
      return '';
    }
  }

  Future<String> getPhoneNumber() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) return '';

      final doc = await sellersCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['phone_number'] ?? '';
      } else {
        print('❌ Seller document not found');
        return '';
      }
    } catch (e) {
      print('❌ Error fetching phone_number: $e');
      return '';
    }
  }

  Future<double> getLongitude() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) return 0;

      final doc = await sellersCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.get('shoplocation.lng');
        print('Longitude: $data');
        return data ?? '';
      } else {
        print('❌ Seller document not found');
        return 0;
      }
    } catch (e) {
      print('❌ Error fetching Longitude: $e');
      return 0;
    }
  }

  Future<double> getLatitude() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) return 0;

      final doc = await sellersCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.get('shoplocation.lat');
        print('Latitude: $data');
        return data ?? '';
      } else {
        print('❌ Seller document not found');
        return 0;
      }
    } catch (e) {
      print('❌ Error fetching Latitude: $e');
      return 0;
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

  /// (Optional) Get offers filtered by seller ID (business_name)
  Stream<List<Offer>> getOffersByBusinessName(String business_name) {
    return offersCollection
        .where('business_name', isEqualTo: business_name)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList());
  }
}
