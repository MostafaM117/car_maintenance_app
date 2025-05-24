import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/screens/user_offers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../services/user_data_helper.dart';
import '../../widgets/CarCardWidget.dart';
import '../../widgets/SubtractWave_widget.dart';
import '../../widgets/maintenance_card.dart';
import '../../Back-end/firestore_service.dart';
import '../../services/mileage_service.dart';
import '../formscreens/formscreen1.dart';
import '../maintenanceDetails.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      // print("🛑 Skipping clone: target collection already exists.");
      return; // Don't clone again
    }

    final sourceSnapshot = await source.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in sourceSnapshot.docs) {
      final targetDoc = target.doc(doc.id);
      batch.set(targetDoc, doc.data());
    }

    await batch.commit();
    // print("✅ Clone complete: "+sourceSnapshot.docs.length.toString()+" docs copied.");
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

            StreamBuilder<QuerySnapshot>(
              stream: carsCollection
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return CircularProgressIndicator();
                // }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator(); // أو أي لودينغ مناسب
                }

                List<Map<String, dynamic>> cars = [];
                for (var doc in snapshot.data!.docs) {
                  Map<String, dynamic> car = doc.data() as Map<String, dynamic>;
                  car['id'] = doc.id;
                  cars.add(car);
                }
                // Set selectedCar to the current car
                if (cars.isNotEmpty && currentCar < cars.length) {
                  selectedCar = cars[currentCar];
                }

                if (cars.isEmpty) {
                  return SizedBox(
                    height: 210,
                    width: 300,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCarScreen()),
                        );
                      },
                      child: Card(
                        color: AppColors.secondaryText,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: AppColors.borderSide,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 4,
                        child: Center(
                          child: Icon(Icons.add,
                              size: 48, color: AppColors.primaryText),
                        ),
                      ),
                    ),
                  );
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
                  height: 210,
                  width: 300,
                  child: CardSwiper(
                    cardsCount: cars.length,
                    cardBuilder: (BuildContext context, int index,
                        int realIndex, int percentThresholdX) {
                      return CarCardWidget(car: cars[index]);
                    },
                    onSwipe: (previousIndex, currentIndex, direction) {
                      if (previousIndex != currentIndex) {
                        setState(() {
                          currentCar = currentIndex!;
                          if (currentCar >= cars.length) {
                            currentCar = 0;
                          }

                          // Update selected car
                          selectedCar = cars[currentCar];
                          // print("�� Switched to car: "+(selectedCar?['make']).toString()+" "+(selectedCar?['model']).toString()+" (ID: "+(selectedCar?['id']).toString()+")");

                          // Update MaintID for correct maintenance collection
                          final make = cars[currentCar]['make'];
                          final model = cars[currentCar]['model'];
                          final year = cars[currentCar]['year'];

                          // Get the MaintID singleton and update it
                          final maintID = MaintID();
                          maintID.selectedMake = make.toString();
                          maintID.selectedModel = model.toString();
                          maintID.selectedYear = year.toString();

                          // Force service update to refresh maintenance items
                          firestoreService = FirestoreService(maintID);
                          // print("💾 Refreshing maintenance data for "+make.toString()+" "+model.toString()+" "+year.toString());

                          // Force a complete rebuild of the widget tree
                          // This ensures maintenance items are completely refreshed
                          Future.delayed(Duration.zero, () {
                            if (mounted) setState(() {});
                          });
                        });
                      }
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
                _buildExploreCard("offers", Icons.local_offer,
                    const Color.fromARGB(255, 73, 209, 78), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserFeedScreen()),
                  );
                }),
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
                // Use a key based on the car ID to force rebuild when car changes
                child: StreamBuilder<List<MaintenanceList>>(
                  key: ValueKey('maintenance-${selectedCar?['id'] ?? 'none'}'),
                  stream: firestoreService.getMaintenanceList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return FutureBuilder<int>(
                      future: MileageService().getCarMileage(
                        selectedCar?['id'] ?? "",
                      ),
                      builder: (context, mileageSnapshot) {
                        if (!mileageSnapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final carMileage = mileageSnapshot.data ?? 0;

                        int avgKmPerMonth = 500;
                        final avgKmValue = selectedCar?["avgKmPerMonth"];
                        if (avgKmValue != null) {
                          if (avgKmValue is int) {
                            avgKmPerMonth = avgKmValue;
                          } else if (avgKmValue is double) {
                            avgKmPerMonth = avgKmValue.toInt();
                          } else if (avgKmValue is String) {
                            avgKmPerMonth = int.tryParse(avgKmValue) ?? 500;
                          }
                        }

                        // print("🚗 Car ID: "+carId.toString()+", Current Mileage: "+carMileage.toString()+", Avg KM/Month: "+avgKmPerMonth.toString());
                        final maintList = snapshot.data!
                            .where((item) => item.isDone != true)
                            .toList();
                        // print("📋 Total maintenance items: "+maintList.length.toString());

                        // Only proceed with mileage check if we have a valid car mileage
                        if (carMileage > 0) {
                          for (final item
                              in List<MaintenanceList>.from(maintList)) {
                            // print("🔧 Maintenance item: "+item.id+", Mileage: "+item.mileage.toString()+", Current car mileage: "+carMileage.toString());

                            // Check if this maintenance item is due based on mileage
                            if (carMileage >= item.mileage && !item.isDone) {
                              // print("🔄 Moving item "+item.id+" to history ("+item.mileage.toString()+" <= "+carMileage.toString()+")");
                              try {
                                firestoreService.moveToHistory(item.id);
                                maintList.remove(item);
                                // print("✅ Successfully moved item "+item.id+" to maintenance history");
                              } catch (e) {
                                // print("❌ Error moving item to history: "+e.toString());
                              }
                            } else {
                              // print("⏳ Item "+item.id+" not yet due ("+item.mileage.toString()+" > "+carMileage.toString()+")");
                            }
                          }
                        } else {
                          // print("! Invalid car mileage: "+carMileage.toString()+". Skipping maintenance checks.");
                        }

                        // Sort maintenance items by mileage
                        maintList
                            .sort((a, b) => a.mileage.compareTo(b.mileage));

                        if (maintList.isEmpty) {
                          return const Center(
                              child: Text("No maintenance records available."));
                        }

                        final upcomingMaintList = maintList
                            .where((item) => item.mileage > carMileage)
                            .take(2)
                            .toList();

                        if (upcomingMaintList.isEmpty) {
                          return const Center(
                              child: Text("No upcoming maintenance needed."));
                        }

                        // print("🔮 Showing "+upcomingMaintList.length.toString()+" upcoming maintenance items");

                        return ListView.builder(
                          itemCount: upcomingMaintList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero, // Remove default padding
                          itemBuilder: (context, index) {
                            final maintenanceItem = upcomingMaintList[index];

                            if (maintenanceItem.isDone == true) {
                              return SizedBox
                                  .shrink(); // Hides the widget visually
                            }

                            return Slidable(
                              key: Key(maintenanceItem.id),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await firestoreService
                                          .moveToHistory(maintenanceItem.id);
                                    },
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    icon: Icons.check,
                                    label: 'Done',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {},
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    icon: Icons.close,
                                    label: 'Cancel',
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MaintenanceDetailsPage(
                                        maintenanceItem: maintenanceItem,
                                      ),
                                    ),
                                  );
                                },
                                child: MaintenanceCard(
                                  title: '${maintenanceItem.mileage} KM',
                                  date: maintenanceItem.formatExpectedDate(
                                      carMileage, avgKmPerMonth),
                                ),
                              ),
                            );
                          },
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
  String title,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 100,
      height: 45,
      decoration: ShapeDecoration(
        color: color, // AppColors.secondaryText or passed color
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
          SizedBox(width: 6),
          Text(
            title[0].toUpperCase() + title.substring(1), // Capitalize
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
