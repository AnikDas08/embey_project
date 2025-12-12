import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/button/common_button.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/component/text/common_text.dart';
import 'package:embeyi/core/component/text_field/common_text_field.dart';
import 'package:embeyi/core/utils/constants/app_colors.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:embeyi/core/utils/constants/app_string.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:embeyi/core/utils/helpers/other_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/config/route/app_routes.dart';
import '../controller/sign_in_controller.dart';
import '../widgets/do_not_account.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ IMPORTANT
      backgroundColor: AppColors.primaryColor,

      /// AppBar
      appBar: CommonAppbar(
        backgroundColor: AppColors.primaryColor,
        leading: const BackButton(color: AppColors.white),
      ),

      /// Body
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: GetBuilder<SignInController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        const CommonText(
                          text: AppString.login,
                          fontSize: 32,
                          bottom: 20,
                          color: AppColors.white,
                        ),

                        /// White Card Section
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                24.height,

                                /// Logo
                                CommonImage(
                                  imageSrc: AppImages.logo,
                                  width: 144.w,
                                  height: 105.h,
                                ),

                                24.height,

                                /// Email
                                const CommonText(
                                  text: AppString.email,
                                  bottom: 8,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ).start,
                                CommonTextField(
                                  controller: controller.emailController,
                                  hintText: AppString.email,
                                  validator: OtherHelper.emailValidator,
                                  textInputAction: TextInputAction.next,
                                ),

                                /// Password
                                const CommonText(
                                  text: AppString.password,
                                  bottom: 8,
                                  top: 24,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ).start,
                                CommonTextField(
                                  controller: controller.passwordController,
                                  isPassword: true,
                                  hintText: AppString.password,
                                  validator: OtherHelper.passwordValidator,
                                  textInputAction: TextInputAction.done,
                                ),

                                /// Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => Get.toNamed(
                                        AppRoutes.forgotPassword),
                                    child: const CommonText(
                                      text: AppString.forgotThePassword,
                                      top: 10,
                                      bottom: 30,
                                      color: AppColors.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                /// Login Button
                                CommonButton(
                                  titleText: AppString.login,
                                  isLoading: controller.isLoading,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.signInUser();
                                    }
                                  },
                                ),

                                60.height,

                                /// Signup Section
                                const DoNotHaveAccount(),
                                20.height,

                                CommonImage(imageSrc: AppImages.or),
                                40.height,

                                /// Social Login
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

                                40.height,
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
          shadows: const [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 37.81,
              offset: Offset(15.12, 15.12),
            ),
          ],
        ),
        child: CommonImage(imageSrc: imageSrc),
      ),
    );
  }
}
