import 'package:flutter/material.dart';
import '../services/mileage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MileageDisplay extends StatefulWidget {
  final String carId;
  final dynamic currentMileage;
  final dynamic avgKmPerMonth;
  final Function(int)? onMileageUpdated;

  const MileageDisplay({
    Key? key,
    required this.carId,
    required this.currentMileage,
    required this.avgKmPerMonth,
    this.onMileageUpdated,
  }) : super(key: key);

  @override
  State<MileageDisplay> createState() => _MileageDisplayState();
}

class _MileageDisplayState extends State<MileageDisplay> {
  final MileageService _mileageService = MileageService();
  late TextEditingController _controller;
  bool _isEditing = false;
  int _displayMileage = 0;

  @override
  void initState() {
    super.initState();
    _loadMileage();
  }
  
  @override
  void didUpdateWidget(MileageDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If the car ID or mileage has changed, reload the mileage
    if (oldWidget.carId != widget.carId || 
        oldWidget.currentMileage != widget.currentMileage) {
      // Dispose of the old controller to prevent memory leaks
      _controller.dispose();
      _loadMileage();
      print('MILEAGE DEBUG: Car changed from ${oldWidget.carId} to ${widget.carId}, reloading mileage');
    }
  }

  Future<void> _loadMileage() async {
    // Get the latest mileage from Firestore to ensure we have the most up-to-date value
    try {
      final carDoc = await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carId)
          .get();
      
      int mileage;
      if (carDoc.exists) {
        final carData = carDoc.data()!;
        mileage = carData['mileage'] is double 
            ? (carData['mileage'] as double).toInt() 
            : carData['mileage'] as int? ?? 0;
      } else {
        // Fallback to the provided mileage if Firestore fetch fails
        mileage = widget.currentMileage is double 
            ? (widget.currentMileage as double).toInt() 
            : widget.currentMileage as int? ?? 0;
      }
      
      setState(() {
        _displayMileage = mileage;
        _controller = TextEditingController(text: mileage.toString());
      });
      
      print('MILEAGE DEBUG: Loaded mileage for car ${widget.carId}: $_displayMileage');
    } catch (e) {
      print('MILEAGE DEBUG: Error loading mileage for car ${widget.carId}: $e');
      
      // Fallback to the provided mileage if Firestore fetch fails
      final mileage = widget.currentMileage is double 
          ? (widget.currentMileage as double).toInt() 
          : widget.currentMileage as int? ?? 0;
      
      setState(() {
        _displayMileage = mileage;
        _controller = TextEditingController(text: mileage.toString());
      });
    }
    
    // Auto-update mileage if needed
    if (widget.avgKmPerMonth != null && widget.avgKmPerMonth > 0) {
      try {
        final updatedMileage = await _mileageService.autoUpdateMileage(widget.carId);
        if (updatedMileage != _displayMileage) {
          setState(() {
            _displayMileage = updatedMileage;
            _controller.text = updatedMileage.toString();
          });
          widget.onMileageUpdated?.call(updatedMileage);
          print('MILEAGE DEBUG: Auto-updated mileage for car ${widget.carId} to $_displayMileage');
        }
      } catch (e) {
        print('MILEAGE DEBUG: Error auto-updating mileage for car ${widget.carId}: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateMileage() async {
    try {
      final newMileage = int.parse(_controller.text);
      
      print('MILEAGE DEBUG: Attempting to update car ${widget.carId} mileage to $newMileage');
      
      // Directly update the specific car document in Firestore
      await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carId)
          .update({
            'mileage': newMileage,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      
      // Verify the update was successful by reading back from Firestore
      final updatedDoc = await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carId)
          .get();
      
      final updatedMileage = updatedDoc.data()?['mileage'];
      print('MILEAGE DEBUG: Verification - car ${widget.carId} mileage is now $updatedMileage in Firestore');
      
      // Update local state
      setState(() {
        _isEditing = false;
        _displayMileage = newMileage;
      });
      
      // Notify parent widget of the update
      if (widget.onMileageUpdated != null) {
        widget.onMileageUpdated!(newMileage);
      }
      
      print('MILEAGE DEBUG: Successfully updated mileage for car ${widget.carId} to $newMileage');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mileage updated successfully to $newMileage km')),
      );
    } catch (e) {
      print('MILEAGE DEBUG: Error updating mileage for car ${widget.carId}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update mileage: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffixText: 'km',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updateMileage,
            color: Colors.green,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isEditing = false;
                _controller.text = _displayMileage.toString();
              });
            },
            color: Colors.red,
          ),
        ],
      );
    }

    return InkWell(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mileage: ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '${_displayMileage}km',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.edit, size: 16),
        ],
      ),
    );
  }
}