import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessnameDisplay extends StatelessWidget {

  final String uid;
  final TextStyle? style;
  const BusinessnameDisplay({super.key, required this.uid, this.style,});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('sellers').doc(uid).snapshots(), 
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data!.exists){
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final businessname = data['business_name']?? '';
          return Text(
            businessname,
            style: style ?? const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Inter',
            ),
            overflow: TextOverflow.ellipsis,
          );
        }
        else{
          return Text('loading...');
        }
      });
  }
}