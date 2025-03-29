class CarData {
  static final CarData _instance = CarData._internal();

  factory CarData() {
    return _instance;
  }

  CarData._internal();

  String selectedMake = '';
  String selectedModel = '';
  String selectedYear = '';

  String get maintID => "$selectedMake $selectedModel $selectedYear";
}
