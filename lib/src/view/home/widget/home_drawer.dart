// ignore: must_be_immutable
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:menu_log/commons/controls/custom_button.dart';
import 'package:menu_log/commons/controls/custom_text.dart';
import 'package:menu_log/commons/controls/custom_textfield.dart';
import 'package:menu_log/src/repository/items/items_cubit.dart';
import 'package:menu_log/src/repository/login/login_bloc.dart';
import 'package:menu_log/src/view/order/pages/current_order.dart';
import 'package:menu_log/src/view/order/pages/order_history.dart';
import 'package:menu_log/utils/app_color.dart';
import 'package:menu_log/utils/extension.dart';

import '../../../repository/image_pick/cubit/image_picker_cubit.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    super.key,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController categoriesController;

  @override
  void initState() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    categoriesController = TextEditingController();
    super.initState();
  }

  // TextEditingController tableNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    firebase_storage.FirebaseStorage myStorage =
        firebase_storage.FirebaseStorage.instance;
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return CurrentOrderPage();
                  },
                ));
              },
              title: CustomText(text: "Current Orders"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return OrderHistoryPage();
                  },
                ));
              },
              title: CustomText(text: "Order History"),
            ),
            createItem(context),
            ListTile(
              title: CustomText(text: 'Log Out'),
              onTap: () {
                context.read<LoginBloc>().add(OnGoogleLogout(context: context));
              },
            ),
            Gap(50.h)
          ],
        ),
      ),
    );
  }

  ListTile createItem(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: CustomText(text: 'Create Table'),
              content: SizedBox(
                height: 400.h,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Item Name',
                      borderSide: BorderSide(),
                    ),
                    Gap(10.h),
                    CustomTextField(
                      hintText: 'Item Price',
                      controller: priceController,
                      borderSide: BorderSide(),
                    ),
                    Gap(10.h),
                    CustomTextField(
                      hintText: 'Item Category',
                      controller: categoriesController,
                      borderSide: BorderSide(),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<ImagePickerCubit>().pickImage();
                      },
                      child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
                        builder: (context, state) {
                          if (state is ImagePickerPicked) {
                            return Image.file(
                              state.myFile,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(
                              height: 13.h,
                              child: const Icon(
                                Icons.image,
                                size: 20,
                              ),
                            ).addMargin(EdgeInsets.only(top: 40, bottom: 20));
                          }
                        },
                      ),
                    ),
                    Gap(10.h),
                    BlocBuilder<ImagePickerCubit, ImagePickerState>(
                      builder: (context, state) {
                        return CustomButton(
                          onTap: () async {
                            if (state is ImagePickerPicked) {
                              //
                              await context
                                  .read<ImagePickerCubit>()
                                  .uploadImage(state.myFile)
                                  .then((value) => context
                                      .read<ItemsCubit>()
                                      .createItems(
                                          nameController.text.trim(),
                                          categoriesController.text.trim(),
                                          priceController.text
                                              .trim()
                                              .toString(),
                                          value));
                            }
                            Navigator.pop(context);
                          },
                          text: 'Save',
                          height: 50,
                          width: 150,
                          textColor: AppColor.white,
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      title: CustomText(text: 'Add item to menu'),
    );
  }
}
