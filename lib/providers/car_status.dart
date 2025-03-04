import 'dart:io';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Car {
  String id;
  String make;
  String model;
  int year;
  double mileage;
  File? image;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    this.image,
  });
}

class CarProvider extends ChangeNotifier {
  Car _car =
      Car(id: '', make: 'Unknown', model: 'Unknown', year: 2000, mileage: 0.0);

  Car get car => _car;

  void updateCar({
    String? make,
    String? model,
    int? year,
    double? mileage,
  }) {
    _car = Car(
      make: make ?? _car.make,
      model: model ?? _car.model,
      year: year ?? _car.year,
      mileage: mileage ?? _car.mileage,
    );
    notifyListeners();
  }
}
//Where to put listeners?
