import 'package:flutter/material.dart';

import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';

class CarMaint extends StatefulWidget {
  const CarMaint({super.key});

  @override
  State<CarMaint> createState() => _CarMaintState();
}

class _CarMaintState extends State<CarMaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  "    My Cars",
                  style: textStyleWhite.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 9.20,
                    
                  ),
                ),
                
              ]),
            ),
          )
        ],
      ),
    );
  }
}
