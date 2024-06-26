import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:menu_log/commons/controls/custom_text.dart';
import 'package:menu_log/src/view/auth/login.dart';
import 'package:menu_log/utils/extension.dart';

import '../../../commons/controls/custom_button.dart';
import '../../../commons/controls/custom_textfield.dart';
import '../../../utils/app_color.dart';
import '../../repository/login/login_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(text: 'SignUp'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Welcome to\nMenulog',
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
            size: 26,
            color: AppColor.black,
          ),
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
            borderSide: BorderSide(color: AppColor.black),
          ),
          const Gap(18),
          CustomTextField(
            controller: passController,
            hintText: 'Enter your password',
            obscureText: true,
            borderSide: BorderSide(
              color: AppColor.black,
            ),
          ),
          const Gap(18),
          CustomTextField(
            controller: confirmPassController,
            hintText: 'confirm your password',
            obscureText: true,
            borderSide: BorderSide(
              color: AppColor.black,
            ),
          ),
          const Gap(18),
          const Gap(10),
          CustomButton(
            radius: 18,
            text: 'Signup',
            textColor: AppColor.white,
            onTap: () {
              if (passController.text.trim() ==
                  confirmPassController.text.trim()) {
                context.read<LoginBloc>().add(OnEmailSignUp(
                    context: context,
                    email: emailController.text.trim(),
                    password: confirmPassController.text.trim()));
              } else {}
            },
          ),
          const Gap(14),
          Center(child: CustomText(text: 'or signup with')),
          Center(
            child: GestureDetector(
              onTap: () {
                context.read<LoginBloc>().add(OnGoogleLogin(context: context));
              },
              child: SvgPicture.asset(
                'lib/commons/assets/google.svg',
                height: 80,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                letterSpacing: 2,
                text: 'Already have an account? ',
                fontWeight: FontWeight.w600,
                color: AppColor.greyText,
              ),
              CustomText(
                onTap: () {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (builder) {
                  //   return LoginPage();
                  // }));
                  Navigator.pop(context);
                },
                letterSpacing: 1.3,
                text: 'Login',
                color: Colors.green.shade300,
                fontWeight: FontWeight.w700,
              )
            ],
          )
        ],
      ).addMargin(const EdgeInsets.only(left: 20, right: 20)),
    );
  }
}
