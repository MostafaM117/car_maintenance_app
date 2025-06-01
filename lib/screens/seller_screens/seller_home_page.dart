import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/models/ProductItemModel.dart';
import 'package:car_maintenance/screens/seller_screens/add_item.dart';
import 'package:car_maintenance/services/seller/seller_data_helper.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/l10n.dart';
import '../../services/ltutorial_service.dart';
import '../../widgets/SubtractWave_widget.dart';
import 'edit_item.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  List<String> items = [];
  FirestoreService firestoreService = FirestoreService(MaintID());
  String username = 'Loading...';
  final seller = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('sellers');
  @override
  void initState() {
    super.initState();
    loadSellername();
  }

  void loadSellername() async {
    String? fetchedUsername = await getSellername();
    if (!mounted) return;
    setState(() {
      username = fetchedUsername ?? 'seller';
    });
  }

  void checkFormCompletion() {
    setState(() {});
  }

  void _editItem(ProductItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItem(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.only(
          right: 11,
          left: 11,
          top: 20,
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            SubtractWave(
              text: S.of(context).welcome_home(username.split(' ').first),
              svgAssetPath: 'assets/svg/notification.svg',
              suptext: S.of(context).support_text,
              onTap: () {},
              onSuptextTap: () {
                TutorialService().showTutorial(context, forceShow: true);
              },
            ),
            const SizedBox(height: 20),
            // Items List
            Expanded(
              child: StreamBuilder<List<ProductItem>>(
                  stream: firestoreService.getStock(),
                  builder: (context, snapshot) {
                    final productList = snapshot.data ?? [];
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: productList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () async {
                              final newItemName = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddItem(),
                                ),
                              );

                              if (newItemName != null) {
                                setState(() {
                                  items.add(newItemName);
                                });
                              }
                            },
                            child: Container(
                              decoration: ShapeDecoration(
                                color: const Color(0x7FF4F4F4),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/add.svg',
                                  width: 40,
                                  height: 40,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                          );
                        }

                        final product = productList[index - 1];
                        return Container(
                          decoration: ShapeDecoration(
                            color: Color(0x7FF4F4F4),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFD9D9D9)),
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  'assets/images/motor_oil.png',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(70),
                                    bottomLeft: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        maxLines: 2, style: textStyleWhite),
                                    Text('In Stock', style: textStyleGray),
                                    Text('${product.price} LE',
                                        style: textStyleGray),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/svg/edit.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          onPressed: () => _editItem(product),
                                        ),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/svg/delete.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          onPressed: () async {
                                            bool confirmDelete = false;

                                            await AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.noHeader,
                                              animType: AnimType.scale,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              dialogBackgroundColor:
                                                  AppColors.borderSide,
                                              dismissOnTouchOutside: true,
                                              body: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .permanentDeleteTitle,
                                                    style: textStyleWhite,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .permanentDeleteMessage,
                                                    style: textStyleGray,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      popUpBotton(
                                                        S.of(context).cancel,
                                                        AppColors.primaryText,
                                                        AppColors.buttonText,
                                                        onPressed: () {
                                                          confirmDelete = false;
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      const SizedBox(width: 15),
                                                      popUpBotton(
                                                        S.of(context).delete,
                                                        AppColors.buttonColor,
                                                        AppColors.buttonText,
                                                        onPressed: () {
                                                          firestoreService
                                                              .deleteProduct(
                                                                  product.id);
                                                          confirmDelete = true;
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ).show();

                                            if (confirmDelete) {
                                              setState(() {
                                                items.removeAt(index);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
