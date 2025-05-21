import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GetShopLocation extends StatefulWidget {
  const GetShopLocation({super.key});

  @override
  State<GetShopLocation> createState() => _GetShopLocationState();
}

class _GetShopLocationState extends State<GetShopLocation> {
  final MapController mapController = MapController();
  LocationData? currentLocation;
  LatLng? manualLocation;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  final mapapiKey = dotenv.env['MAP_API_KEY'];

  //Get Current Location
  Future <void> _getCurrentLocation() async{
    var location = Location();
    try{
      var storeLocation = await location.getLocation();
      setState(() {
        currentLocation = storeLocation;
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: LatLng(storeLocation.latitude!, storeLocation.longitude!), 
            child: Column(
              children: [
                Text('My Location', style: TextStyle(fontWeight: FontWeight.bold),),
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                  ),
              ],
            ))
        );
      });
    }
    on Exception{
      currentLocation =null;
    }
    location.onLocationChanged.listen((LocationData newlocation){
      setState(() {
        currentLocation = newlocation;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Get your location'),
      //   backgroundColor: Colors.transparent,
      // ),
      body: currentLocation == null ?
      Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Getting Your Current Location...', 
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          CircularProgressIndicator(color: Colors.black),
        ],
      ),)
      : Stack(
        alignment: Alignment.center,
        children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            initialZoom: 13.0,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all
            )
          ),
          children: [
            TileLayer(
              // https://api.maptiler.com/maps/bright-v2/{z}/{x}/{y}.png?key=4GEVTqDb8SkybNQXGIZe
              // urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=4GEVTqDb8SkybNQXGIZe',
              // urlTemplate: 'https://api.maptiler.com/maps/basic-v2/256/{z}/{x}/{y}.png?key=4GEVTqDb8SkybNQXGIZe',
              urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=4GEVTqDb8SkybNQXGIZe',
              userAgentPackageName: 'com.example.car_maintenance',
              // subdomains: const ['a', 'b', 'c'],
            ),
            // MarkerLayer(markers: markers),
            Align(
              alignment: Alignment.center,
              child: IgnorePointer(
                child: Icon(Icons.location_on, size: 50, color: Colors.red,),
              ),
            ),
          ]
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: 
              buildButton(
                'Save Location',
                AppColors.primaryText,
                AppColors.buttonText,
                onPressed: () {
                  final manualLocation = mapController.camera.center;
                  Navigator.pop(context, manualLocation);
                  // if(currentLocation != null){
                  //   Navigator.pop(context, LatLng(
                  //     currentLocation!.latitude!,
                  //     currentLocation!.longitude!,));
                  // }
                },
                )),
        Positioned(
          bottom: 90,
          right: 20,
          child: FloatingActionButton(
            onPressed: (){
              if(currentLocation != null){
                mapController.move(LatLng(currentLocation!.latitude!, currentLocation!.longitude!), 17.0);
              }
            },
            backgroundColor: AppColors.background,
            child: Icon(Icons.my_location_outlined),
            ),
        ),
      ]),
    );
  }
}