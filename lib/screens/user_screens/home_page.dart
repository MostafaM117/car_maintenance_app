import 'package:car_maintenance/AI-Chatbot/chatbot.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/generated/l10n.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/screens/addMaintenance.dart';
import 'package:car_maintenance/screens/user_screens/user_offers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:flutter_svg/svg.dart';
import '../../services/ltutorial_service.dart';
import '../../services/user_data_helper.dart';
import '../../widgets/CarCardWidget.dart';
import '../../widgets/SubtractWave_widget.dart';
import '../../widgets/exploreCard.dart';
import '../../widgets/maintenance_card.dart';
import '../../Back-end/firestore_service.dart';
import '../../services/mileage_service.dart';
import '../formscreens/formscreen1.dart';
import '../maintenanceDetails.dart';
import '../../notifications/notification.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'notifications .dart';

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
  late Stream<List<Map<String, dynamic>>> carsStream;
  List<Map<String, dynamic>> cars = [];
  Map<String, dynamic>? selectedCar;
  int currentCar = 0;
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

    // Initialize notifications when the app starts
    _initializeNotifications();

    // Listen for changes in the cars collection
    _setupCarsListener();
  }

  // Setup listener for changes in the cars collection
  void _setupCarsListener() {
    carsCollection
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        // No cars available, clear maintenance data
        setState(() {
          selectedCar = null;
          cars = [];
          currentCar = 0;
          // Reset MaintID to clear maintenance data
          final maintID = MaintID();
          maintID.selectedMake = '';
          maintID.selectedModel = '';
          maintID.selectedYear = '';
          firestoreService = FirestoreService(maintID);
        });
      } else {
        // Update cars list
        List<Map<String, dynamic>> updatedCars = [];
        for (var doc in snapshot.docs) {
          Map<String, dynamic> car = doc.data() as Map<String, dynamic>;
          car['id'] = doc.id;
          updatedCars.add(car);
        }

        setState(() {
          cars = updatedCars;

          // If selected car was deleted, select the first car
          if (selectedCar != null) {
            final stillExists =
                cars.any((car) => car['id'] == selectedCar!['id']);
            if (!stillExists && cars.isNotEmpty) {
              currentCar = 0;
              selectedCar = cars[0];

              // Update MaintID for the new selected car
              final maintID = MaintID();
              maintID.selectedMake = selectedCar!['make'].toString();
              maintID.selectedModel = selectedCar!['model'].toString();
              maintID.selectedYear = selectedCar!['year'].toString();

              // Update firestore service
              firestoreService = FirestoreService(maintID);
            }
          } else if (cars.isNotEmpty) {
            // No car was selected, select the first one
            currentCar = 0;
            selectedCar = cars[0];

            // Update MaintID for the new selected car
            final maintID = MaintID();
            maintID.selectedMake = selectedCar!['make'].toString();
            maintID.selectedModel = selectedCar!['model'].toString();
            maintID.selectedYear = selectedCar!['year'].toString();

            // Update firestore service and clone maintenance data
            firestoreService = FirestoreService(maintID);
            cloneMaintenanceToUser(
              source: firestoreService.maintCollection,
              target: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection(
                      'Maintenance_Schedule_${MaintID().maintID}_Personal'),
            );
          }
        });
      }
    });
  }

  void _updateService() {
    setState(() {
      firestoreService = FirestoreService(MaintID());

      // Only clone maintenance data if a car is selected
      if (selectedCar != null) {
        cloneMaintenanceToUser(
          source: firestoreService.maintCollection,
          target: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('Maintenance_Schedule_${MaintID().maintID}_Personal'),
        );
      }
    });
  }

  // Initialize the notification service
  Future<void> _initializeNotifications() async {
    final notiService = NotiService();
    await notiService.initNotification();
  }

  // void _showTutorial() {
  //   TutorialCoachMark(
  //     targets: targets,
  //     colorShadow: Colors.black,
  //     textSkip: "تخطي",
  //     opacityShadow: 0.8,
  //   ).show(context: context);
  // }
  void someFunction(BuildContext context) {
    TutorialService().showTutorial(context);
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
          top: 30,
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            SubtractWave(
              text: username != null
                  ? S.of(context).welcome_home(username!.split(' ').first)
                  : S.of(context).welcome_home('user'),
              svgAssetPath: 'assets/svg/notification.svg',
              suptext: S.of(context).support_text,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(),
                    ));
              },
              onSuptextTap: () {
                TutorialService().showTutorial(context, forceShow: true);
              },
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: carsCollection
                          .where('userId', isEqualTo: user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        // This is now handled by the _setupCarsListener method
                        // We'll keep this code here just for the UI building part
                        List<Map<String, dynamic>> carsFromSnapshot = [];
                        for (var doc in snapshot.data!.docs) {
                          Map<String, dynamic> car =
                              doc.data() as Map<String, dynamic>;
                          car['id'] = doc.id;
                          carsFromSnapshot.add(car);
                        }

                        if (carsFromSnapshot.isEmpty) {
                          return SizedBox(
                            height: 210,
                            width: 300,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCarScreen()),
                                ).then((_) {
                                  // Force refresh when returning from add car screen
                                  setState(() {});
                                });
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

                        int cardsToDisplay = carsFromSnapshot.length > 3
                            ? 3
                            : carsFromSnapshot.length;

                        return SizedBox(
                          height: 210,
                          width: 300,
                          child: CardSwiper(
                            cardsCount: carsFromSnapshot.length,
                            cardBuilder: (BuildContext context, int index,
                                int realIndex, int percentThresholdX) {
                              return CarCardWidget(
                                  car: carsFromSnapshot[index]);
                            },
                            onSwipe: (previousIndex, currentIndex, direction) {
                              if (previousIndex != currentIndex) {
                                setState(() {
                                  currentCar = currentIndex!;
                                  if (currentCar >= carsFromSnapshot.length) {
                                    currentCar = 0;
                                  }

                                  // Update selected car
                                  selectedCar = carsFromSnapshot[currentCar];
                                  // print("Switched to car: "+(selectedCar?['make']).toString()+" "+(selectedCar?['model']).toString()+" (ID: "+(selectedCar?['id']).toString()+")");

                                  // Update MaintID for correct maintenance collection
                                  final make =
                                      carsFromSnapshot[currentCar]['make'];
                                  final model =
                                      carsFromSnapshot[currentCar]['model'];
                                  final year =
                                      carsFromSnapshot[currentCar]['year'];

                                  // Get the MaintID singleton and update it
                                  final maintID = MaintID();
                                  maintID.selectedMake = make.toString();
                                  maintID.selectedModel = model.toString();
                                  maintID.selectedYear = year.toString();

                                  firestoreService = FirestoreService(maintID);
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
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: Align(
                        alignment:
                            Directionality.of(context) == TextDirection.rtl
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Text(
                          S.of(context).explore,
                          // textAlign: TextAlign.start,
                          style: TextStyle(
                            color: const Color(0xFF0F0F0F),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    // Add Explore cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ExploreCard(
                            title: S.of(context).add_maintenanceh,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMaintenance()),
                              );
                            }),
                        ExploreCard(
                            title: S.of(context).ask_chatbot,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chatbot(
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid),
                                ),
                              );
                            }),
                        ExploreCard(
                            title: S.of(context).checkout_offers,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserFeedScreen()),
                              );
                            }),
                      ],
                    ),
                    // SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).next_maintenance,
                            style: TextStyle(
                              color: const Color(0xFF0F0F0F),
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _showMaintenancePopup(context);
                            },
                            child: Text(
                              S.of(context).view_all,
                              style: TextStyle(
                                color: AppColors.buttonColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 8),
                    // Maintenance List
                    SingleChildScrollView(
                      padding: EdgeInsets.zero, // Remove default padding
                      // Use a key based on the car ID to force rebuild when car changes
                      child: selectedCar == null
                          ? Center(
                              child: Text(
                                  "Please add a car to see maintenance items"))
                          : StreamBuilder<List<MaintenanceList>>(
                              key: ValueKey(
                                  'maintenance-${selectedCar?['id'] ?? 'none'}-${DateTime.now().millisecondsSinceEpoch}'),
                              stream: firestoreService.getMaintenanceList(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Center(
                                      child: CircularProgressIndicator());
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

                                    final carMileage =
                                        mileageSnapshot.data ?? 0;

                                    int avgKmPerMonth = 500;
                                    final avgKmValue =
                                        selectedCar?["avgKmPerMonth"];
                                    if (avgKmValue != null) {
                                      if (avgKmValue is int) {
                                        avgKmPerMonth = avgKmValue;
                                      } else if (avgKmValue is double) {
                                        avgKmPerMonth = avgKmValue.toInt();
                                      } else if (avgKmValue is String) {
                                        avgKmPerMonth =
                                            int.tryParse(avgKmValue) ?? 500;
                                      }
                                    }
                                    final maintList = snapshot.data!
                                        .where((item) => item.isDone != true)
                                        .toList();
                                    if (carMileage > 0) {
                                      for (final item
                                          in List<MaintenanceList>.from(
                                              maintList)) {
                                        if (carMileage >= item.mileage &&
                                            !item.isDone) {
                                          try {
                                            firestoreService
                                                .moveToHistory(item.id);
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
                                    maintList.sort((a, b) =>
                                        a.mileage.compareTo(b.mileage));

                                    if (maintList.isEmpty) {
                                      return Center(
                                        child: Text(
                                          S.of(context).no_maintenance_records,
                                        ),
                                      );
                                    }

                                    final upcomingMaintList = maintList
                                        .where(
                                            (item) => item.mileage > carMileage)
                                        .toList();
                                    final displayedMaintList =
                                        upcomingMaintList.take(2).toList();

                                    final notiService = NotiService();
                                    // Initialize notifications first
                                    notiService.initNotification();

                                    notiService.cancelNotification();

                                    final carMake =
                                        selectedCar?['make'] ?? 'Your car';
                                    final carModel =
                                        selectedCar?['model'] ?? '';
                                    final carInfo = '$carMake $carModel';

                                    for (final item in displayedMaintList) {
                                      final expectedDate =
                                          item.calculateExpectedDate(
                                              carMileage, avgKmPerMonth);
                                      final formattedDate =
                                          item.formatExpectedDate(
                                              carMileage, avgKmPerMonth);
                                      final notifyDate = expectedDate
                                          .subtract(const Duration(days: 7));

                                      // Schedule the notification if it's in the future
                                      if (notifyDate.isAfter(DateTime.now())) {
                                        notiService.scheduleNotificationAtDate(
                                          id: item.id.hashCode,
                                          title:
                                              'Maintenance Reminder: $carInfo',
                                          body:
                                              '${item.mileage} KM maintenance is due on $formattedDate',
                                          dateTime: notifyDate,
                                        );
                                      }
                                    }

                                    if (displayedMaintList.isEmpty) {
                                      return Center(
                                          child: Text(S
                                              .of(context)
                                              .no_upcoming_maintenance));
                                    }
                                    return ListView.builder(
                                      itemCount: displayedMaintList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets
                                          .zero, // Remove default padding
                                      itemBuilder: (context, index) {
                                        final maintenanceItem =
                                            displayedMaintList[index];

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
                                                      .moveToHistory(
                                                          maintenanceItem.id);
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
                                                  builder: (_) =>
                                                      MaintenanceDetailsPage(
                                                    maintenanceItem:
                                                        maintenanceItem,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: MaintenanceCard(
                                              title:
                                                  '${maintenanceItem.mileage} KM',
                                              date: maintenanceItem
                                                  .formatExpectedDate(
                                                      carMileage,
                                                      avgKmPerMonth),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMaintenancePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.secondaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).all_upcoming_maintenance,
                      style: TextStyle(
                        color: AppColors.buttonColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<List<MaintenanceList>>(
                    stream: firestoreService.getMaintenanceList(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final maintList = snapshot.data!
                          .where((item) => item.isDone != true)
                          .toList();

                      if (maintList.isEmpty) {
                        return Center(
                            child: Text(S.of(context).no_maintenance_records));
                      }

                      return FutureBuilder<int>(
                        future: MileageService()
                            .getCarMileage(selectedCar?["id"] ?? ""),
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

                          maintList
                              .sort((a, b) => a.mileage.compareTo(b.mileage));

                          final upcomingMaintList = maintList
                              .where((item) => item.mileage > carMileage)
                              .toList();

                          return ListView.builder(
                            itemCount: upcomingMaintList.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final maintenanceItem = upcomingMaintList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
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
                              );
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
        );
      },
    );
  }
}
