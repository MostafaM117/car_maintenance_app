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
import '../services/mileage_service.dart';
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
                // Set selectedCar to the current car
                if (cars.isNotEmpty && currentCar < cars.length) {
                  selectedCar = cars[currentCar];
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
                      if (previousIndex != currentIndex) {
                        setState(() {
                          itemCheckedStates.clear();
                          
                          // Update current car index
                          currentCar = currentIndex!;
                          if (currentCar >= cars.length) {
                            currentCar = 0;
                          }
                          
                          // Update selected car
                          selectedCar = cars[currentCar];
                          print("🔄 Switched to car: ${selectedCar?['make']} ${selectedCar?['model']} (ID: ${selectedCar?['id']})");

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
                          print("💾 Refreshing maintenance data for ${make} ${model} ${year}");
                          
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
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final carId = selectedCar?["id"] ?? "";
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
                        
                        print("🚗 Car ID: $carId, Current Mileage: $carMileage, Avg KM/Month: $avgKmPerMonth");
                        final maintList = snapshot.data!
                            .where((item) => item.isDone != true)
                            .toList();
                        print("📋 Total maintenance items: ${maintList.length}");
                        
                        // Only proceed with mileage check if we have a valid car mileage
                        if (carMileage > 0) {
                          for (final item in List<MaintenanceList>.from(maintList)) {
                            print("🔧 Maintenance item: ${item.id}, Mileage: ${item.mileage}, Current car mileage: $carMileage");
                            
                            // Check if this maintenance item is due based on mileage
                            if (carMileage >= item.mileage && !item.isDone) {
                              print("🔄 Moving item ${item.id} to history (${item.mileage} <= $carMileage)");
                              try {
                                firestoreService.moveToHistory(item.id);
                                maintList.remove(item);
                                print("✅ Successfully moved item ${item.id} to maintenance history");
                              } catch (e) {
                                print("❌ Error moving item to history: $e");
                              }
                            } else {
                              print("⏳ Item ${item.id} not yet due (${item.mileage} > $carMileage)");
                            }
                          }
                        } else {
                          print("! Invalid car mileage: $carMileage. Skipping maintenance checks.");
                        }
                        
                        // Sort maintenance items by mileage
                        maintList.sort((a, b) => a.mileage.compareTo(b.mileage));
                        
                        if (maintList.isEmpty) {
                          return const Center(child: Text("No maintenance records available."));
                        }
                        
                        final upcomingMaintList = maintList
                            .where((item) => item.mileage > carMileage)
                            .take(2)
                            .toList();
                        
                        if (upcomingMaintList.isEmpty) {
                          return const Center(child: Text("No upcoming maintenance needed."));
                        }
                        
                        print("🔮 Showing ${upcomingMaintList.length} upcoming maintenance items");
                        
                        return ListView.builder(
                          itemCount: upcomingMaintList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero, // Remove default padding
                          itemBuilder: (context, index) {
                            final maintenanceItem = upcomingMaintList[index];

                            if (!itemCheckedStates.containsKey(maintenanceItem.id)) {
                              itemCheckedStates[maintenanceItem.id] = false;
                            }
                            
                            if (maintenanceItem.isDone == true) {
                              return SizedBox.shrink(); // Hides the widget visually
                            }

                            return Dismissible(
                              key: Key(maintenanceItem.id),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: const Color.fromARGB(255, 94, 255, 82),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                              onDismissed: (direction) async {
                                await firestoreService.moveToHistory(maintenanceItem.id);
                                setState(() {
                                  itemCheckedStates[maintenanceItem.id] = true;
                                });
                                print("✅ Moved to history");
                              },
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
                                  date: maintenanceItem.formatExpectedDate(carMileage, avgKmPerMonth),
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
