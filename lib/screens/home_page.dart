// import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/AI-Chatbot/chatbot.dart';
import 'package:car_maintenance/widgets/car_image_widget.dart'; // Updated import for car image widget
import 'package:car_maintenance/widgets/mileage_display.dart';
import 'package:car_maintenance/services/car_image_service.dart'; // Import service for car images
import '../services/user_data_helper.dart';
// import '../widgets/SubtractWave_widget.dart';
import 'formscreens/formscreen1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  String? username;

  // Track currently selected car for image display
  Map<String, dynamic>? selectedCar;
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder:(context) => AuthPage(),));
        //       FirebaseAuth.instance.signOut();
        //     },
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Signed in as ${user.email}"),
            SizedBox(height: 20),
            // WaveTag(
            //   text: username != null
            //       ? 'Welcome Back, $username'
            //       : 'Welcome Back, User',
            //   svgAssetPath: 'assets/svg/notification.svg',
            //   onTap: (){},
            // ),
            // Add Car Button (original UI)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCarScreen()),
                );
              },
              icon: Icon(Icons.directions_car),
              label: Text('Add Car'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            SizedBox(height: 20),

            // Car image display area
            if (selectedCar != null)
              Column(
                children: [
                  Text(
                    '${selectedCar!['year']} ${selectedCar!['make']} ${selectedCar!['model']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: CarImageWidget(
                      make: selectedCar!['make'],
                      model: selectedCar!['model'],
                      year: selectedCar!['year'],
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

            SizedBox(height: 20),

            // Simple car selector dropdown
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cars')
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
                  car['id'] = doc.id; // Add document ID to identify the car
                  cars.add(car);
                }

                // Reset selectedCar if it's not in the list anymore
                if (selectedCar != null) {
                  bool found =
                      cars.any((car) => car['id'] == selectedCar!['id']);
                  if (!found) {
                    // Need to use Future.microtask to avoid changing state during build
                    Future.microtask(() => setState(() => selectedCar = null));
                  }
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select a car to view its image'),
                      value: selectedCar?['id'] as String?,
                      onChanged: (String? value) {
                        if (value != null) {
                          final selectedCarData =
                              cars.firstWhere((car) => car['id'] == value);
                          setState(() {
                            selectedCar = selectedCarData;
                          });
                        } else {
                          setState(() {
                            selectedCar = null;
                          });
                        }
                      },
                      items: cars.map<DropdownMenuItem<String>>((car) {
                        return DropdownMenuItem<String>(
                          value: car['id'] as String,
                          child: Text(
                              '${car['year']} ${car['make']} ${car['model']}'),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Chatbot()),
          );
        },
        label: const Text('Chatbot'),
        icon: const Icon(Icons.chat),
        backgroundColor: Color(0xFFD1A3FF), // Light purple
      ),
    );
  }
}
