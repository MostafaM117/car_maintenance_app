import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import '../widgets/BackgroundDecoration.dart';
import '../../widgets/custom_widgets.dart';
import '../Periodicpage.dart';

class Market extends StatelessWidget {
  Market({super.key});
  // final List<String> categories = ['Periodic', 'Used', 'Unused'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> categories = [
      l10n.periodicCategory,
      l10n.usedCategory,
      l10n.unusedCategory
    ];
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
                      l10n.market,
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
                      itemCount: categories.length,
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
                                builder: (context) =>
                                    Periodicpage(title: categories[index]),
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
