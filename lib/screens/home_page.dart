import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
// import 'package:car_maintenance/screens/addMaintenance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import '../AI-Chatbot/chatbot.dart';
import '../services/user_data_helper.dart';
import '../widgets/CarCardWidget.dart';
import '../widgets/SubtractWave_widget.dart';
import '../widgets/maintenance_card.dart';
import '../Back-end/firestore_service.dart';
// import 'maintenance.dart';
import 'maintenanceDetails.dart';
// import 'market.dart';

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
  int currentCar = 0;

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
        source: firestoreService.maintCollection,
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
        padding: const EdgeInsets.only(
          right: 11,
          left: 11,
          top: 20,
        ),
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (cars.isNotEmpty) {
                    final newMake = cars[currentCar]['make'].toString();
                    final newModel = cars[currentCar]['model'].toString();
                    final newYear = cars[currentCar]['year'].toString();

                    final maintID = MaintID();
                    if (maintID.selectedMake != newMake ||
                        maintID.selectedModel != newModel ||
                        maintID.selectedYear != newYear) {
                      maintID.selectedMake = newMake;
                      maintID.selectedModel = newModel;
                      maintID.selectedYear = newYear;
                    }
                  }
                });
                int cardsToDisplay = cars.length > 3 ? 3 : cars.length;

                return SizedBox(
                  height: 200,
                  width: 300,
                  child: CardSwiper(
                    cardsCount: cars.length,
                    cardBuilder: (BuildContext context, int index,
                        int realIndex, int percentThresholdX) {
                      return CarCardWidget(car: cars[index]);
                    },
                    onSwipe: (previousIndex, currentIndex, direction) {
                      setState(() {
                        currentCar = currentIndex!;
                        if (currentCar >= cars.length) {
                          currentCar = 0;
                        }

                        final make = cars[currentCar]['make'];
                        final model = cars[currentCar]['model'];
                        final year = cars[currentCar]['year'];

                        MaintID().selectedMake = make.toString();
                        MaintID().selectedModel = model.toString();
                        MaintID().selectedYear = year.toString();
                      });
                      return true;
                    },
                    numberOfCardsDisplayed: cardsToDisplay,
                    padding: EdgeInsets.only(bottom: 0),
                    backCardOffset: const Offset(22, 22),
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Explore',
                  style: TextStyle(
                    color: const Color(0xFF0F0F0F),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Add Explore cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildExploreCard(),
                _buildExploreCard(),
                _buildExploreCard(),
              ],
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Next Maintenance',
                  style: TextStyle(
                    color: const Color(0xFF0F0F0F),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Maintenance List
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero, // Remove default padding
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
                        .toList()
                      ..sort((a, b) =>
                          a.mileage.compareTo(b.mileage)); // Sort by date

                    if (maintList.isEmpty) {
                      return Center(
                          child: Text("No maintenance records available."));
                    }

                    return ListView.builder(
                      itemCount: maintList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero, // Remove default padding
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
                        // print(maintenanceItem.isDone);

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

Widget _buildExploreCard(
    // BuildContext context, String title, IconData icon, Color color, VoidCallback onTap
    ) {
  return GestureDetector(
    // onTap: ,
    child: Container(
      width: 100,
      height: 45,
      decoration: ShapeDecoration(
        color: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 8),
          // Text(
          //   title,
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.black87,
          //   ),
          // ),
        ],
      ),
    ),
  );
}
