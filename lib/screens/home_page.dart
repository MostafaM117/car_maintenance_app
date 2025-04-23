import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/screens/addMaintenance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../services/user_data_helper.dart';
import 'package:car_maintenance/widgets/mileage_display.dart';
import '../widgets/CarCardWidget.dart';
import '../widgets/SubtractWave_widget.dart';
import '../widgets/maintenance_card.dart';
import '../Back-end/firestore_service.dart';
import 'maintenanceDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');
  String? username;
  Map<String, dynamic>? selectedCar;
  FirestoreService firestoreService = FirestoreService(MaintID());
  Map<String, bool> itemCheckedStates = {};

  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }

  Future<void> cloneMaintenanceToUser({
    required CollectionReference source,
    required CollectionReference target,
  }) async {
    // 🔍 Check if target collection already has docs
    final targetSnapshot = await target.limit(1).get();

    if (targetSnapshot.docs.isNotEmpty) {
      print("🛑 Skipping clone: target collection already exists.");
      return; // Don't clone again
    }

    final sourceSnapshot = await source.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in sourceSnapshot.docs) {
      final targetDoc = target.doc(doc.id);
      batch.set(targetDoc, doc.data());
    }

    await batch.commit();
    print("✅ Clone complete: ${sourceSnapshot.docs.length} docs copied.");
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
    firestoreService = FirestoreService(MaintID());
    MaintID().addListener(_updateService);
  }

  void _updateService() {
    setState(() {
      firestoreService = FirestoreService(MaintID());
      cloneMaintenanceToUser(
        source: FirebaseFirestore.instance
            .collection('Maintenance_Schedule_${MaintID().maintID}'),
        target: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Maintenance_Schedule_${MaintID().maintID}_Personal'),
      );
    });
  }

  @override
  void dispose() {
    MaintID().removeListener(_updateService);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 40),
        child: Column(
          children: [
            SizedBox(height: 10),
            SubtractWave(
              text: username != null
                  ? 'Welcome Back, ${username!.split(' ').first}'
                  : 'Welcome Back, User',
              svgAssetPath: 'assets/svg/notification.svg',
              onTap: () {},
            ),
            SizedBox(height: 15),

            // Display cars
            StreamBuilder<QuerySnapshot>(
              stream: carsCollection
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No cars found. Add a car to see its image.');
                }

                List<Map<String, dynamic>> cars = [];
                for (var doc in snapshot.data!.docs) {
                  Map<String, dynamic> car = doc.data() as Map<String, dynamic>;
                  car['id'] = doc.id;
                  cars.add(car);
                }

                int cardsToDisplay = cars.length > 3 ? 3 : cars.length;

                return SizedBox(
                  height: 210,
                  width: 300,
                  child: CardSwiper(
                    cardsCount: cars.length,
                    cardBuilder: (BuildContext context, int index,
                        int realIndex, int percentThresholdX) {
                      return CarCardWidget(car: cars[index]);
                    },
                    numberOfCardsDisplayed: cardsToDisplay,
                    padding: EdgeInsets.only(bottom: 0),
                    backCardOffset: const Offset(25, 30),
                  ),
                );
              },
            ),
            SizedBox(height: 40),

            SubtractWave(
              text: 'Next Maintenance',
              svgAssetPath: 'assets/svg/add.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMaintenance()),
                );
              },
            ),
            SizedBox(height: 15),

            // Maintenance List
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<List<MaintenanceList>>(
                  stream: firestoreService.getMaintenanceList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final maintList = snapshot.data!
                        .where((item) =>
                            item.isDone !=
                            true) // Only show items that are not done
                        .toList();

                    if (maintList.isEmpty) {
                      return Center(
                          child: Text("No maintenance records available."));
                    }

                    return ListView.builder(
                      itemCount: maintList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final maintenanceItem = maintList[index];

                        if (!itemCheckedStates
                            .containsKey(maintenanceItem.id)) {
                          itemCheckedStates[maintenanceItem.id] = false;
                        }
                        if (maintenanceItem.isDone == true) {
                          return SizedBox.shrink();
                          // Hides the widget visually
                        }
                        print(maintenanceItem.isDone);

                        return Dismissible(
                          key: Key(maintenanceItem.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: const Color.fromARGB(255, 94, 255, 82),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.check, color: Colors.white),
                          ),
                          onDismissed: (direction) async {
                            await firestoreService.moveToHistory(maintenanceItem
                                .id); // This updates `isDone` in Firestore

                            setState(() {
                              itemCheckedStates[maintenanceItem.id] =
                                  true; // This updates the local UI state
                            });

                            print("✅ Moved to history");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Moved to history successfully')),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MaintenanceDetailsPage(
                                      maintenanceItem: maintenanceItem),
                                ),
                              );
                            },
                            child: MaintenanceCard(
                              title: '${maintenanceItem.mileage} KM',
                              date: maintenanceItem.expectedDate
                                  .toString()
                                  .split(' ')[0],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
