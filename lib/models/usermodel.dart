import "package:flutter/material.dart";
import "package:car_maintenance/providers/car_status.dart";

class User {
  String username;
  String password;
  String email;
  Car car;
  String carId;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.car,
    required this.carId,
  });
}
