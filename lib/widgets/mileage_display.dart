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

  Future<void> _updateMileage() async {
    if (!mounted) return;

    try {
      final newMileage = int.parse(_controller.text);

      await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carId)
          .update({
        'mileage': newMileage,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() {
          _isEditing = false;
          _displayMileage = newMileage;
        });

        widget.onMileageUpdated?.call(newMileage);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Mileage updated successfully to $newMileage km')),
        );
      }
    } catch (e) {
      if (mounted) {
        print(
            'MILEAGE DEBUG: Error updating mileage for car ${widget.carId}: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update mileage: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                isDense: true,
                suffixText: 'km',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 16),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: _updateMileage,
            color: Colors.green,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
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
