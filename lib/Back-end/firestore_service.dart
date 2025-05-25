import 'package:car_maintenance/models/ProductItemModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_maintenance/Back-end/offer_service.dart';
// import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference maintCollection;
  final user = FirebaseAuth.instance.currentUser;
  late final CollectionReference historyCollection;
  late final CollectionReference personalMaintCollection;
  late final CollectionReference productsCollection;
  late final CollectionReference stockCollection;
  final OfferService offerService = OfferService();
  
  FirestoreService(MaintID maintID)
      : maintCollection = FirebaseFirestore.instance
            .collection('Maintenance_Schedule_${MaintID().maintID}') {
    personalMaintCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Maintenance_Schedule_${MaintID().maintID}_Personal');
    historyCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("maintHistory ${MaintID().maintID}");
    productsCollection = FirebaseFirestore.instance
        .collection('products'); // Collection for products
    stockCollection = FirebaseFirestore.instance
        .collection('sellers')
        .doc(user!.uid)
        .collection('stock'); // Collection for stock
  }

  //add special cases
  Future<void> addSpecialMaintenance(String description, bool isDone,
      int mileage, DateTime expectedDate) async {
    try {
      await historyCollection.add({
        "Description": description,
        "isDone": true, // Always set to true for history items
        "mileage": mileage,
        "expectedDate": expectedDate
      });
      print("✅ Added completed maintenance to history: $mileage KM");
    } catch (e) {
      print("❌ Error adding maintenance to history: $e");
    }
  }

  Future<void> cloneMaintenanceToUser({
    required CollectionReference source,
    required CollectionReference target,
  }) async {
    final sourceSnapshot = await source.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in sourceSnapshot.docs) {
      final targetDoc = target.doc(doc.id);
      batch.set(targetDoc, doc.data());
    }

    await batch.commit();
  }

  //add product
  Future<void> addProduct(
    String name,
    String description,
    String selectedMake,
    String selectedModel,
    String selectedCategory,
    String selectedAvailability,
    int stockCount,
    double price,
  ) async {
    final businessName = await offerService.getBusinessName();
    try {
      await stockCollection.add({
        'name': name,
        'Description': description,
        'selectedMake': selectedMake,
        'selectedModel': selectedModel,
        'selectedCategory': selectedCategory,
        'selectedAvailability': selectedAvailability,
        'stockCount': stockCount,
        'price': price,
        'Store Name': businessName
      });
      await productsCollection.add({
        'name': name,
        'Description': description,
        'selectedMake': selectedMake,
        'selectedModel': selectedModel,
        'selectedCategory': selectedCategory,
        'selectedAvailability': selectedAvailability,
        'stockCount': stockCount,
        'price': price,
        'Store Name': businessName
      });
      print("✅ Added product item");
    } catch (e) {
      print("❌ Error adding product item: $e");
    }
  }

  //get products
  Stream<List<ProductItem>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return ProductItem(
          id: doc.id,
          name: data['name'] ?? '',
          price: data['price'] ?? 0,
          description: data['Description'] ?? '',
          selectedMake: data['selectedMake'] ?? '',
          selectedModel: data['selectedModel'] ?? '',
          selectedCategory: data['selectedCategory'] ?? '',
          selectedAvailability: data['selectedAvailability'] ?? '',
          stockCount: data['stockCount'] ?? 0,
        );
      }).toList();
    });
  }

  Stream<List<ProductItem>> getFilteredProducts({
    String? make,
    String? model,
    double? minPrice,
    double? maxPrice,
    String? location,
  }) {
    Query query = productsCollection;

    if (make != null && make.isNotEmpty) {
      query = query.where('selectedMake', isEqualTo: make);
    }

    if (model != null && model.isNotEmpty) {
      query = query.where('selectedModel', isEqualTo: model);
    }

    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    // if (location != null && location.isNotEmpty) {
    //   query = query.where('selectedAvailability', isEqualTo: location);
    // }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductItem(
          id: doc.id,
          name: data['name'],
          price: data['price'],
          description: data['Description'],
          selectedMake: data['selectedMake'],
          selectedModel: data['selectedModel'],
          selectedCategory: data['selectedCategory'],
          selectedAvailability: data['selectedAvailability'],
          stockCount: data['stockCount'],
        );
      }).toList();
    });
  }

  Stream<List<ProductItem>> getStock() {
    return stockCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return ProductItem(
          id: doc.id,
          name: data['name'] ?? '',
          price: data['price'] ?? 0,
          description: data['Description'] ?? '',
          selectedMake: data['selectedMake'] ?? '',
          selectedModel: data['selectedModel'] ?? '',
          selectedCategory: data['selectedCategory'] ?? '',
          selectedAvailability: data['selectedAvailability'] ?? '',
          stockCount: data['stockCount'] ?? 0,
        );
      }).toList();
    });
  }

  Future<void> updateProduct(
    String docId,
    String name,
    String description,
    String selectedMake,
    String selectedModel,
    String selectedCategory,
    String selectedAvailability,
    int stockCount,
    double price,
  ) async {
    try {
      await stockCollection.doc(docId).update({
        'name': name,
        'Description': description,
        'selectedMake': selectedMake,
        'selectedModel': selectedModel,
        'selectedCategory': selectedCategory,
        'selectedAvailability': selectedAvailability,
        'stockCount': stockCount,
        'price': price
      });
      print("✅ Updated product item with ID: $docId");
    } catch (e) {
      print("❌ Error updating product item: $e");
    }
  }

  Future<void> deleteProduct(String docId) async {
    try {
      await stockCollection.doc(docId).delete();
      // await productsCollection.doc(docId).delete();
      print("✅ Deleted product with ID: $docId");
    } catch (e) {
      print("❌ Error deleting maintenance item: $e");
    }
  }

  //get maint lists
  Stream<List<MaintenanceList>> getMaintenanceList() {
    return personalMaintCollection
        // .limit(9) // Add this line to limit to 9 documents
        .snapshots()
        .map((snapshot) {
      print("📡 Firestore returned ${snapshot.docs.length} documents");

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};

        DateTime expected;
        try {
          expected = (data['expectedDate'] as Timestamp?)?.toDate() ??
              DateTime.now().add(Duration(days: 30));
        } catch (_) {
          expected = DateTime.now().add(Duration(days: 30));
        }

        return MaintenanceList(
          id: doc.id,
          description: data['Description'] ?? '',
          mileage: (data['mileage'] ?? 0) as int,
          expectedDate: expected,
          isDone: (data['isDone'] ?? false) as bool,
        );
      }).toList();
    });
  }

  // Method to copy a maintenance item to the history collection
  Future<void> moveToHistory(String docId) async {
    try {
      final docSnapshot = await personalMaintCollection.doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Make sure isDone is set to true in the data
        data['isDone'] = true;
        
        // Add to history collection with isDone=true
        await historyCollection.doc(docId).set(data);
        
        // Delete from personal collection after successful copy
        await personalMaintCollection.doc(docId).delete();
        
        print("✅ Moved maintenance item to history: $docId");
      } else {
        print("❌ No data found for docId: $docId");
      }
    } catch (e) {
      print("❌ Error moving maintenance to history: $e");
    }
  }

  // Future<void> deleteMaintenance(String docId) async {
  // try {
  //  await personalMaintCollection.doc(docId).delete();
  // print("✅ Deleted maintenance item with ID: $docId");
  // } catch (e) {
  // print("❌ Error deleting maintenance item: $e");
  // }
  //}

  Stream<List<MaintenanceList>> getMaintenanceHistory() {
    return historyCollection.snapshots().map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return MaintenanceList.fromJson(data, doc.id);
      }).toList();
      
      // Sort maintenance history items by mileage in ascending order
      items.sort((a, b) => a.mileage.compareTo(b.mileage));
      
      return items;
    });
  }

  Future<void> recoverFromHistory(String docId) async {
    try {
      final docSnapshot = await historyCollection.doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Make sure isDone is set to false for the active item
        data['isDone'] = false;
        
        // Add to personal collection with the same document ID
        await personalMaintCollection.doc(docId).set(data);
        
        // Delete from history collection after successful copy
        await historyCollection.doc(docId).delete();
        
        print("✅ Recovered maintenance item from history: $docId");
      } else {
        print("❌ No data found for docId: $docId");
      }
    } catch (e) {
      print("❌ Error recovering maintenance from history: $e");
    }
  }

  Future<void> updateMaintenance(
    String docId,
    String description,
    int mileage,
    DateTime expectedDate,
    bool isDone,
  ) async {
    try {
      await personalMaintCollection.doc(docId).update({
        'Description': description,
        'mileage': mileage,
        'expectedDate': expectedDate,
        'isDone': isDone,
      });
      print("✅ Updated maintenance item with ID: $docId");
    } catch (e) {
      print("❌ Error updating maintenance item: $e");
    }
  }

  Future<void> updateHistory(
    String docId,
    String description,
    int mileage,
    DateTime expectedDate,
    bool isDone,
  ) async {
    try {
      await historyCollection.doc(docId).update({
        'Description': description,
        'mileage': mileage,
        'expectedDate': expectedDate,
        'isDone': isDone,
      });
      print("✅ Updated maintenance item with ID: $docId");
    } catch (e) {
      print("❌ Error updating maintenance item: $e");
    }
  }

  Future<void> clearHistory() async {
    try {
      final snapshot = await historyCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print("✅ Cleared all history items");
    } catch (e) {
      print("❌ Error clearing history: $e");
    }
  }

  Future<void> addMaintenance(
    String description,
    bool isDone,
    int mileage,
    DateTime expectedDate,
  ) async {
    try {
      await personalMaintCollection.add({
        'Description': description,
        'mileage': mileage,
        'expectedDate': expectedDate,
        'isDone': false,
      });
      print("✅ Added maintenance item");
    } catch (e) {
      print("❌ Error adding maintenance item: $e");
    }
  }
}