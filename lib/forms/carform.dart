import 'dart:io';
import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _avgKmPerMonthController = TextEditingController();
  
  String? _selectedMake;
  String? _selectedModel;
  int? _selectedYear;
  DateTime? _lastMaintenanceDate;
  bool _isLoading = false;

  final Map<String, List<String>> _carModels = {
    'Chevrolet': ['Camaro', 'Aveo'],
    'Hyundai': ['Elantra', 'Sonata'],
  };

  final List<int> _years = [2020, 2021, 2022, 2023, 2024, 2025];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Car')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Make'),
                value: _selectedMake,
                items: _carModels.keys.map((String make) {
                  return DropdownMenuItem<String>(
                    value: make,
                    child: Text(make),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMake = newValue;
                    _selectedModel = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select car make';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Model'),
                value: _selectedModel,
                items: _selectedMake == null
                    ? []
                    : _carModels[_selectedMake]!.map((String model) {
                        return DropdownMenuItem<String>(
                          value: model,
                          child: Text(model),
                        );
                      }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModel = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select car model';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Year'),
                value: _selectedYear,
                items: _years.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Current Mileage (km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current mileage';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _avgKmPerMonthController,
                decoration: InputDecoration(labelText: 'Average Kilometers per Month'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter average kilometers per month';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              ListTile(
                title: Text('Last Maintenance Date'),
                subtitle: Text(_lastMaintenanceDate == null
                    ? 'Select a date'
                    : '${_lastMaintenanceDate!.day}/${_lastMaintenanceDate!.month}/${_lastMaintenanceDate!.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _lastMaintenanceDate ?? DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _lastMaintenanceDate) {
                    setState(() {
                      _lastMaintenanceDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Add Car'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_lastMaintenanceDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select last maintenance date')),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        await _saveCar();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen() ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding car: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _saveCar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      throw Exception('User document not found');
    }
    
    final username = userDoc.data()?['username'] as String?;
    if (username == null) {
      throw Exception('Username not found');
    }

    final carId = FirebaseFirestore.instance.collection('cars').doc().id;

    final lastMaintenanceDate = DateTime(
      _lastMaintenanceDate!.year,
      _lastMaintenanceDate!.month,
      _lastMaintenanceDate!.day,
    );

    await FirebaseFirestore.instance.collection('cars').doc(carId).set({
      'carId': carId,
      'make': _selectedMake,
      'model': _selectedModel,
      'year': _selectedYear,
      'mileage': double.parse(_mileageController.text.trim()),
      'avgKmPerMonth': double.parse(_avgKmPerMonthController.text.trim()),
      'lastMaintenance': Timestamp.fromDate(lastMaintenanceDate),
      'userId': user.uid,
      'username': username,
    });
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'carAdded': true,
    });
  }
}