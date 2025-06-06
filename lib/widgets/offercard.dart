import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String date;
  final String? imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OfferCard({
    super.key,
    required this.title,
    required this.date,
    this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 180,
          child: Stack(
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      height: 180,
                      width: MediaQuery.of(context).size.width - 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: Center(child: Text('No Image')),
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: textStyleWhite.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            date,
                            style: textStyleWhite.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/edit.svg',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: onEdit,
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/delete.svg',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                animType: AnimType.scale,
                                dialogBackgroundColor: AppColors.secondaryText,
                                body: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Are you sure you want to delete this offer?',
                                        style: textStyleWhite.copyWith(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'This action is permanent and cannot be undone. All your data will be permanently removed.',
                                        style: textStyleGray,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 25),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          popUpBotton(
                                            'Cancel',
                                            AppColors.primaryText,
                                            AppColors.buttonText,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          const SizedBox(width: 15),
                                          popUpBotton(
                                            'Delete',
                                            AppColors.buttonColor,
                                            AppColors.buttonText,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              onDelete(); 
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ).show();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class UserOfferCard extends StatelessWidget {
  final String title;
  final String discount;
  final String sellerName;
  final String date;
  final String? imageUrl;

  const UserOfferCard({
    super.key,
    required this.title,
    required this.discount,
    required this.sellerName,
    required this.date,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 180,
          child: Stack(
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      height: 180,
                      width: MediaQuery.of(context).size.width - 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Center(child: Text('No Image')),
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText,
                    borderRadius:  BorderRadius.circular(16)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row: Title + Discount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textStyleWhite.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            discount,
                            style: textStyleWhite
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sellerName,
                        style: textStyleWhite.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: textStyleWhite.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

