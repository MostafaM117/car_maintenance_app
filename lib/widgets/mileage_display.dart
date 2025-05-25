import 'package:flutter/material.dart';
import '../services/mileage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A widget that displays and allows editing of a car's mileage
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

  static void showMileageEditDialog(BuildContext context, String carId, int currentMileage, {Function(int)? onMileageUpdated}) {
    final editController = TextEditingController(text: currentMileage.toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Mileage'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Mileage',
                  suffixText: 'km',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                try {
                  final newMileage = int.parse(editController.text);
                  
                  await FirebaseFirestore.instance
                      .collection('cars')
                      .doc(carId)
                      .update({
                    'mileage': newMileage,
                    'lastUpdated': FieldValue.serverTimestamp(),
                  });
                  
                  onMileageUpdated?.call(newMileage);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mileage updated successfully to $newMileage km')),
                  );
                  
                  Navigator.of(context).pop();
                } catch (e) {
                  print('MILEAGE DEBUG: Error updating mileage for car $carId: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update mileage: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  State<MileageDisplay> createState() => _MileageDisplayState();
}

class _MileageDisplayState extends State<MileageDisplay> {
  final MileageService _mileageService = MileageService();
  late TextEditingController _controller;
  int _displayMileage = 0;

  @override
  void initState() {
    super.initState();
    _loadMileage();
  }

  @override
  void didUpdateWidget(MileageDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.carId != widget.carId ||
        oldWidget.currentMileage != widget.currentMileage) {
      _loadMileage();
    }
  }

  Future<void> _loadMileage() async {
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
        mileage = widget.currentMileage is double
            ? (widget.currentMileage as double).toInt()
            : widget.currentMileage as int? ?? 0;
      }

      setState(() {
        _displayMileage = mileage;
        _controller = TextEditingController(text: mileage.toString());
      });
    } catch (e) {
      print('MILEAGE DEBUG: Error loading mileage for car ${widget.carId}: $e');

      final mileage = widget.currentMileage is double
          ? (widget.currentMileage as double).toInt()
          : widget.currentMileage as int? ?? 0;

      setState(() {
        _displayMileage = mileage;
        _controller = TextEditingController(text: mileage.toString());
      });
    }

    if (widget.avgKmPerMonth != null && widget.avgKmPerMonth > 0) {
      try {
        final updatedMileage =
            await _mileageService.autoUpdateMileage(widget.carId);
        if (updatedMileage != _displayMileage) {
          setState(() {
            _displayMileage = updatedMileage;
            _controller.text = updatedMileage.toString();
          });
          widget.onMileageUpdated?.call(updatedMileage);
        }
      } catch (e) {
        print(
            'MILEAGE DEBUG: Error auto-updating mileage for car ${widget.carId}: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Use the static method directly, passing the state data
        MileageDisplay.showMileageEditDialog(
          context, 
          widget.carId, 
          _displayMileage,
          onMileageUpdated: (newMileage) {
            if (mounted) {
              setState(() {
                _displayMileage = newMileage;
              });
              widget.onMileageUpdated?.call(newMileage);
            }
          }
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mileage: ',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            '$_displayMileage km',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.edit, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}
