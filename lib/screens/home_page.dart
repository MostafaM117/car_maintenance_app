import 'package:car_maintenance/constants/app_colors.dart';
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
// import 'maintenance.dart';
// import 'formscreens/formscreen1.dart';
// import 'package:car_maintenance/models/MaintID.dart';

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

  // Fetch username for greeting (optional)
  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 40),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SubtractWave(
              text: username != null
                  ? 'Welcome Back, ${username!.split(' ').first}'
                  : 'Welcome Back, User',
              svgAssetPath: 'assets/svg/notification.svg',
              onTap: () {},
            ),

            SizedBox(height: 15),

            // Displaying cars in Swiper or Card
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

                // Convert documents to List of Maps
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
                    padding: EdgeInsets.only(
                      bottom: 0,
                    ),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MaintenanceCard(
                      title: '40,000' '  KM',
                      date: 'Upcoming',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaintenanceCard(
                      title: '40,000' '  KM',
                      date: 'Upcoming',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaintenanceCard(
                      title: '40,000' '  KM',
                      date: 'Upcoming',
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
}