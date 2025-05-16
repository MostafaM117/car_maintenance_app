import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import '../notifications/notification.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/maintenance_card.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  late FirestoreService firestoreService;
  final MaintID maintID = MaintID();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(maintID);
    maintID.addListener(_updateService);
  }

  void _updateService() {
    setState(() {
      firestoreService = FirestoreService(maintID);
    });
  }

  @override
  void dispose() {
    maintID.removeListener(_updateService);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Maintenance',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 9.20,
                  ),
                ),
                // const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<MaintenanceList>>(
                    stream: firestoreService.getMaintenanceHistory(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final historyList = snapshot.data!;
                      if (historyList.isEmpty) {
                        return const Center(
                            child: Text("No maintenance history available."));
                      }

                      return ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final maintenanceItem = historyList[index];

                          return Dismissible(
                            key: Key(maintenanceItem.id),
                            direction: DismissDirection.endToStart,
                            child: MaintenanceCard(
                              title: '${maintenanceItem.mileage} KM',
                              date: 'Completed',
                            ),
                            onDismissed: (direction) async {
                              await firestoreService
                                  .recoverFromHistory(maintenanceItem.id);
                              print("✅ Moved to history");
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedButton(
                'Add Maintenance',
                AppColors.buttonColor,
                AppColors.buttonText,
                onPressed: () {
                  NotiService().showNotification(
                    title: 'Maintenance Added!',
                    body: descriptionController.text,
                  );
                  if (selectedDate != null) {
                    firestoreService.addSpecialMaintenance(
                        descriptionController.text, false, 0, selectedDate!);
                  } else {
                    // Handle case when date is not selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a date')),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     firestoreService.cloneMaintenanceToUser(
      //       source: FirebaseFirestore.instance
      //           .collection('Maintenance_Schedule_MG ZS 2019'),
      //       target: FirebaseFirestore.instance
      //           .collection('Maintenance_Schedule_MG ZS 2020'),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
