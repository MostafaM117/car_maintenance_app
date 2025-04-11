import 'package:flutter/foundation.dart';

class MaintID extends ChangeNotifier {
  static final MaintID _instance = MaintID._internal();

  factory MaintID() => _instance;

  MaintID._internal();

  String _selectedMake = '';
  String _selectedModel = '';
  String _selectedYear = '';

  String get selectedMake => _selectedMake;
  String get selectedModel => _selectedModel;
  String get selectedYear => _selectedYear;

  set selectedMake(String value) {
    _selectedMake = value;
    notifyListeners();
  }

  set selectedModel(String value) {
    _selectedModel = value;
    notifyListeners();
  }

  set selectedYear(String value) {
    _selectedYear = value;
    notifyListeners();
  }

  String get maintID => "$_selectedMake $_selectedModel $_selectedYear";
}
