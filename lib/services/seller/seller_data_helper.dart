import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getSellername() async {
  final seller = FirebaseAuth.instance.currentUser;
  if (seller != null) {
    final docSnapshot = await FirebaseFirestore.instance.collection('sellers').doc(seller.uid).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return data['shopname'];
    }
  }
  return null;
}
