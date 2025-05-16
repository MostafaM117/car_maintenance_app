class CarData {
  static final Map<String, Map<String, List<int>>> carMakeModelYears = {
    'Chevrolet': {
      'Optra': [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023],
      'Aveo': [2014, 2015, 2016, 2017, 2018, 2019, 2020],
    },
    'Kia': {
      'Rio': [2014, 2015, 2016, 2017, 2018, 2019, 2020],
      'Cerato': [2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024],
      'Sportage': [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
    },
    'Fiat': {
      'Tipo': [2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
    },
    'Hyundai': {
      'Elantra HD': [ 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024],
      'Accent RB': [2014, 2015, 2016, 2017, 2018, 2019, 2021, 2022, 2023, 2025],
      'Tucson': [2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
      'Elantra AD': [2017, 2018, 2019, 2020, 2025],
      'Elantra CN7': [2021, 2022, 2023, 2024, 2025],
    },
    'Nissan': {
      'Sunny': [2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
      'Sentra': [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
    },
    'Renault': {
      'Megane': [2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
      'Logan': [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022],
      'Fluence': [2014, 2015, 2016, 2017],
    },
    'Toyota': {
      'Corolla': [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025],
      'Yaris': [2015, 2016, 2017, 2018, 2019],
    },
    'MG': {
      'ZS': [2019, 2020, 2021, 2022, 2023, 2024, 2025],
      '5': [2020, 2021, 2022, 2023, 2024, 2025],
    },
  };

  /// Helper method to get available years for a specific make and model
  static List<int> getYearsForModel(String? make, String? model) {
    if (make == null || model == null) {
      return [];
    }
    
    try {
      return carMakeModelYears[make]?[model] ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Helper method to get all available models for a specific make
  static List<String> getModelsForMake(String? make) {
    if (make == null) {
      return [];
    }
    
    try {
      return carMakeModelYears[make]?.keys.toList() ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Helper method to get all available car makes
  static List<String> getAllMakes() {
    return carMakeModelYears.keys.toList();
  }
} 