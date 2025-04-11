import 'package:flutter/material.dart';
import '../services/mileage_service.dart';

class MileageDisplay extends StatefulWidget {
  final String carId;
  final dynamic currentMileage;
  final Function(int)? onMileageUpdated;

  const MileageDisplay({
    Key? key,
    required this.carId,
    required this.currentMileage,
    this.onMileageUpdated,
  }) : super(key: key);

  @override
  State<MileageDisplay> createState() => _MileageDisplayState();
}

class _MileageDisplayState extends State<MileageDisplay> {
  final MileageService _mileageService = MileageService();
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final mileage = widget.currentMileage is double 
        ? (widget.currentMileage as double).toInt() 
        : widget.currentMileage as int? ?? 0;
    _controller = TextEditingController(text: mileage.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateMileage() async {
    try {
      final newMileage = int.parse(_controller.text);
      await _mileageService.updateCarMileage(widget.carId, newMileage);
      setState(() {
        _isEditing = false;
      });
      widget.onMileageUpdated?.call(newMileage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update mileage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayMileage = widget.currentMileage is double 
        ? (widget.currentMileage as double).toInt() 
        : widget.currentMileage as int? ?? 0;

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
                _controller.text = displayMileage.toString();
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
            '${displayMileage}km',
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