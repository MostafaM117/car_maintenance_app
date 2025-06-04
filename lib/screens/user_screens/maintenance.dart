import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/screens/addMaintenance.dart';
import 'package:car_maintenance/screens/HistoryDetails.dart';
// import 'package:car_maintenance/screens/maintenanceDetails.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../generated/l10n.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/maintenance_card.dart';

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
                Text(
                  S.of(context).maintenance,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
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

                      // Make sure the list is sorted by mileage
                      historyList
                          .sort((a, b) => a.mileage.compareTo(b.mileage));

                      return ListView.builder(
                        itemCount: historyList.length,
                        padding: EdgeInsets.only(bottom: 50),
                        itemBuilder: (context, index) {
                          final maintenanceItem = historyList[index];

                          return Slidable(
                            key: Key(maintenanceItem.id),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                // SlidableAction(
                                //   onPressed: (context) async {
                                //     await firestoreService
                                //         .recoverFromHistory(maintenanceItem.id);
                                //   },
                                //   backgroundColor: Colors.white,
                                //   foregroundColor: Colors.black,
                                //   icon: Icons.undo,
                                //   label: S.of(context).undo,
                                // ),
                                SlidableAction(
                                  onPressed: (context) {
                                    firestoreService.recoverFromHistory(maintenanceItem.id);
                                  },
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  icon: Icons.delete,
                                  label: S.of(context).delete,
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HistoryDetailsPage(
                                      maintenanceItem: maintenanceItem,
                                    ),
                                  ),
                                ).then((_) {
                                  // Refresh the UI when coming back from details
                                  setState(() {});
                                });
                              },
                              child: MaintenanceCard(
                                title: '${maintenanceItem.mileage} KM',
                                date: 'Completed',
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
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildButton(
                S.of(context).add_maintenance,
                AppColors.buttonColor,
                AppColors.buttonText,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMaintenance()),
                  );
                },
              ),
            ),
          ),
          // We need to move this button somewhere else
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   color: Colors.grey,
          //   onPressed: () {
          //     firestoreService.clearHistory();
          //   },
          // ),
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
