import 'package:flutter/material.dart';

class CarImageService {
  static String getCarImagePath(String? make, String? model, int? year) {
    if (make == null || model == null || year == null) {
      return 'assets/images/default_car.png';
    }

    String basePath = 'assets/images/cars/';
    String imagePath = '';

    // Toyota models 
    if (make == 'Toyota' && model == 'Corolla') {
      if (year >= 2019) {
        imagePath = '${basePath}Toyota_Corolla_2019_2025.png';
      } else {
        imagePath = '${basePath}Toyota_Corolla_2015_2018.png';
      }
    } else if (make == 'Toyota' && model == 'Yaris') {
      imagePath = '${basePath}Toyota_Yaris_2015_2019.png';
    }

    // Kia models 
    else if (make == 'Kia' && model == 'Cerato') {
      if (year >= 2019 && year <= 2021) {
        imagePath = '${basePath}Kia_Cerato_2019_2021.png';
      } else if (year >= 2022 && year <= 2024) {
        imagePath = '${basePath}Kia_Cerato_2022_2024.png';
      } else {
        imagePath = '${basePath}Kia_Cerato_2014_2018.png';
      }
    } else if (make == 'Kia' && model == 'Rio') {
      imagePath = '${basePath}Kia_Rio_2014_2020.png';
    } else if (make == 'Kia' && model == 'Sportage') {
      if (year >= 2023) {
        imagePath = '${basePath}Kia_Sportage_2023_2025.png';
      } else if (year >= 2017 && year <= 2022) {
        imagePath = '${basePath}Kia_Sportage_2017_2022.png';
      } else {
        imagePath = '${basePath}Kia_Sportage_2015_2016.png';
      }
    }

    // Hyundai models 
    else if (make == 'Hyundai' && model == 'Accent RB') {
      imagePath = '${basePath}Hyundai_Accent_RB_2014_2025.png';
    } else if (make == 'Hyundai' && model == 'Elantra HD') {
      imagePath = '${basePath}Hyundai_Elantra_HD_2017_2024.png';
    } else if (make == 'Hyundai' && model == 'Elantra AD') {
      if (year >= 2019) {
        imagePath = '${basePath}Hyundai_Elantra_AD_2019_2025.png';
      } else if (year == 2017 || year == 2018) {
        imagePath = '${basePath}Hyundai_Elantra_AD_2017_2018.png';
      }
    } else if (make == 'Hyundai' && model == 'Elantra CN7') {
      imagePath = '${basePath}Hyundai_Elantra_CN7_2021_2025.png';
    } else if (make == 'Hyundai' && model == 'Tucson') {
      if (year >= 2021) {
        imagePath = '${basePath}Hyundai_Tucson_2021_2025.png';
      } else {
        imagePath = '${basePath}Hyundai_Tucson_2017_2020.png';
      }
    }

    // Nissan models 
    else if (make == 'Nissan' && model == 'Sunny') {
      imagePath = '${basePath}Nissan_Sunny_2017_2025.png';
    } else if (make == 'Nissan' && model == 'Sentra') {
      imagePath = '${basePath}Nissan_Sentra_2015_2025.png';
    }

    // Chevrolet models 
    else if (make == 'Chevrolet' && model == 'Optra') {
      if (year >= 2015) {
        imagePath = '${basePath}Chevrolet_Optra_2015_2023.png';
      }
    } else if (make == 'Chevrolet' && model == 'Aveo') {
      imagePath = '${basePath}Chevrolet_Aveo_2014_2020.png';
    }

    // MG models
    else if (make == 'MG' && model == '5') {
      imagePath = '${basePath}MG_5_2020_2025.png';
    } else if (make == 'MG' && model == 'ZS') {
      imagePath = '${basePath}MG_ZS_2019_2025.png';
    }

    // Fiat models 
    else if (make == 'Fiat' && model == 'Tipo') {
      if(year >= 2017 && year <= 2021  )
      imagePath = '${basePath}Fiat_Tipo_2017_2021.png';
      else {
      imagePath = '${basePath}Fiat_Tipo_2022_2025.png';
      }
    }
    
    // Renault models 
    else if (make == 'Renault' && model == 'Megane') {
      imagePath = '${basePath}Renault_Megane_2017_2025.png';
    } else if (make == 'Renault' && model == 'Logan') {
      if (year >= 2018) {
        imagePath = '${basePath}Renault_Logan_2018_2022.png';
      } else {
        imagePath = '${basePath}Renault_Logan_2015_2017.png';
      }
    } else if (make == 'Renault' && model == 'Fluence') {
      imagePath = '${basePath}Renault_Fluence_2014_2017.png';
    }

    // Default pattern
    else {
      imagePath = '${basePath}${make}_${model.replaceAll(' ', '_')}.png';
    }

    return imagePath;
  }

  /// Get car image widget 
  static Widget getCarImageWidget(
    String? make,
    String? model,
    int? year, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color fallbackIconColor = Colors.grey,
    double fallbackIconSize = 60,
  }) {
    final imagePath = getCarImagePath(make, model, year);

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.directions_car,
          size: fallbackIconSize,
          color: fallbackIconColor,
        );
      },
    );
  }
}