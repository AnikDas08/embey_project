import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../../../../../../core/component/text_field/common_text_field.dart';
import '../controller/forget_password_controller.dart';
import '../../../../../../core/utils/constants/app_string.dart';
import '../../../../../../core/utils/helpers/other_helper.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.primaryColor,

        /// App Bar Section
        appBar: CommonAppbar(
          backgroundColor: AppColors.primaryColor,
          leading: const BackButton(color: AppColors.white),
        ),

        /// body section
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CommonText(
                text: AppString.forgotPassword,
                fontSize: 30,
                bottom: 20,
                color: AppColors.white,
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 190.h,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        40.height,
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CommonImage(imageSrc: AppIcons.forgotPassword),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const CommonText(
                            text:
                                "Enter your registered email to get password reset instructions",
                            bottom: 8,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            maxLines: 2,
                          ).center,
                        ),
          
                        /// forget password take email for reset Password
                        const CommonText(
                          text: AppString.email,
                          bottom: 8,
                          top: 10,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ).start,
                        CommonTextField(
                          controller: controller.emailController,
          
                          hintText: AppString.email,
                          validator: OtherHelper.emailValidator,
                        ),
                        20.height,
                        CommonButton(
                          titleText: AppString.continues,
                          isLoading: controller.isLoadingEmail,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.forgotPasswordRepo();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        /// Bottom Navigation Bar Section
      ),
    );
  }
}
