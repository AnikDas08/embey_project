import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../core/utils/constants/app_string.dart';
import '../widget/already_accunt_rich_text.dart';
import '../widget/sign_up_all_filed.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      /// App Bar Section Starts Here
      appBar: CommonAppbar(
        backgroundColor: AppColors.primaryColor,
        leading: const BackButton(color: AppColors.white),
      ),

      /// Body Section Starts Here
      body: SingleChildScrollView(
        child: GetBuilder<SignUpController>(
          builder: (controller) {
            return Column(
              children: [
                const CommonText(
                  text: AppString.registration,
                  fontSize: 32,
                  bottom: 20,
                  color: AppColors.white,
                ),

                Container(
                  height: Get.size.height,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Form(
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        CommonImage(
                          imageSrc: AppImages.logo,
                          width: 144.w,
                          height: 105.h,
                        ),

                        /// All Text Filed here
                        SignUpAllField(controller: controller),

                        8.height,
                    Row(
                      children: [
                        Checkbox(
                          value: controller.isTermsAccepted,
                          onChanged: controller.toggleTermsAcceptance,
                          activeColor: AppColors.primaryColor,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "I Agree to the",
                                  style: TextStyle(color: AppColors.black),
                                ),
                                TextSpan(
                                  text: " Terms & Privacy Policy ",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                        8.height,

                        /// Submit Button Here
                        CommonButton(
                          titleText: AppString.signUp,
                          isLoading: controller.isLoading,
                          onTap: controller.signUpUser,
                        ),
                        24.height,

                        ///  Sign In Instruction here
                        const AlreadyAccountRichText(),
                        40.height,
                        CommonImage(imageSrc: AppImages.or),
                        20.height,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialLogin(AppImages.google, () {}),
                            16.width,
                            _socialLogin(AppImages.apple, () {}),
                            16.width,
                            _socialLogin(AppImages.linkedin, () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _socialLogin(String imageSrc, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.76,
              color: Colors.black.withValues(alpha: 0.13),
            ),
            borderRadius: BorderRadius.circular(8.32),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 37.81,
              offset: Offset(15.12, 15.12),
              spreadRadius: 0,
            ),
          ],
        ),
        child: CommonImage(imageSrc: imageSrc),
      ),
    );
  }
}
