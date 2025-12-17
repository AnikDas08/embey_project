import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/core/utils/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../controller/forget_password_controller.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../core/utils/constants/app_string.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final formKey = GlobalKey<FormState>();

  /// init State here
  @override
  void initState() {
    ForgetPasswordController.instance.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      /// App Bar Section
      appBar: CommonAppbar(
        backgroundColor: AppColors.primaryColor,
        leading: const BackButton(color: AppColors.white),
      ),

      /// Body Section
      body: Column(
        children: [
          GetBuilder<ForgetPasswordController>(
            builder: (controller) => Column(
              children: [
                const CommonText(
                  text: AppString.otpVerification,
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          40.height,
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CommonImage(imageSrc: AppIcons.otp),
                          ),

                          /// instruction how to get OTP
                          Center(
                            child: CommonText(
                              text:
                                  "${AppString.codeHasBeenSendTo} ${controller.emailController.text}",
                              fontSize: 16.sp,
                              top: 10,
                              bottom: 60,
                              maxLines: 2,
                            ),
                          ),

                          /// OTP Filed here
                          Flexible(
                            flex: 0,
                            child: PinCodeTextField(
                              controller: controller.otpController,
                              validator: (value) {
                                if (value != null && value.length == 6) {
                                  return null;
                                } else {
                                  return AppString.otpIsInValid;
                                }
                              },
                              autoDisposeControllers: false,
                              cursorColor: AppColors.black,
                              appContext: (context),
                              autoFocus: true,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                fieldHeight: 60.h,
                                fieldWidth: 60.w,
                                activeFillColor: AppColors.transparent,
                                selectedFillColor: AppColors.transparent,
                                inactiveFillColor: AppColors.transparent,
                                borderWidth: 0.5.w,
                                selectedColor: AppColors.primaryColor,
                                activeColor: AppColors.primaryColor,
                                inactiveColor: AppColors.secondaryText,
                              ),
                              length: 6,
                              keyboardType: TextInputType.number,
                              autovalidateMode: AutovalidateMode.disabled,
                              enableActiveFill: true,
                            ),
                          ),

                          /// Resent OTP or show Timer
                          /*GestureDetector(
                            onTap: controller.time == '00:00'
                                ? () {
                                    controller.startTimer();
                                    controller.forgotPasswordRepo();
                                  }
                                : () {},
                            child: CommonText(
                              text: controller.time == '00:00'
                                  ? AppString.resendCode
                                  : "${AppString.resendCodeIn} ${controller.time} ${AppString.minute}",
                              top: 0,
                              bottom: 20,
                              fontSize: 18,
                            ),
                          ),*/

                          ///  Submit Button here
                          CommonButton(
                            titleText: AppString.verify,
                            isLoading: controller.isLoadingVerify,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                controller.verifyOtpRepo();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
