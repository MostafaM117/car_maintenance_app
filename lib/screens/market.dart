import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
// import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';
import 'Periodicpage.dart';

class Market extends StatelessWidget {
  Market({super.key});
  final List<String> categories = ['Periodic', 'Used', 'Unused'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Center(
                    child: Text(
                      "Market",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    // width: 250,
                    height: 450,
                    child: Swiper(
                      itemCount: 3,
                      layout: SwiperLayout.DEFAULT,
                      itemWidth: MediaQuery.of(context).size.width * 0.75,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Periodicpage(),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: AppColors.primaryText,
                            elevation: 6,
                            child: Center(
                              child: Text(
                                categories[index],
                                style: textStyleWhite.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
