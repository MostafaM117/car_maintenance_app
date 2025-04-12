class MaintID {
  static final MaintID _instance = MaintID._internal();

  factory MaintID() {
    return _instance;
  }

  MaintID._internal();

  String selectedMake = '';
  String selectedModel = '';
  String selectedYear = '';

  String get maintID => "$selectedMake $selectedModel $selectedYear";
}
