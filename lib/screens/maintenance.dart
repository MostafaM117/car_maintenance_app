import 'dart:ffi';

import 'package:flutter/material.dart';

class MaintenanceInstance {
  String maint_ID;
  String maint_Desc;
  Int maint_Date;
  bool Case;

  MaintenanceInstance({
    required this.maint_ID,
    required this.maint_Date,
    required this.maint_Desc,
    required this.Case,
  });
}

class Maintenance_Screen extends StatefulWidget {
  const Maintenance_Screen({super.key});

  @override
  State<Maintenance_Screen> createState() => _Maintenance_ScreenState();
}

class _Maintenance_ScreenState extends State<Maintenance_Screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Maintenance Schedule'),
          bottom: TabBar(tabs: [
            Tab(text: 'Upcoming'),
            Tab(
              text: 'History',
            )
          ]),
        ),
        body: TabBarView(children: <Widget>[
          Column(),
          Column(),
        ]),
      ),
    );
  }
}
