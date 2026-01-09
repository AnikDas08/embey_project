import 'package:embeyi/core/component/image/common_image.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/component/button/common_button.dart';
import '../../../../../../core/component/text/common_text.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../core/utils/constants/app_string.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    SignUpController.instance.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      /// App Bar Section starts here
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: const BackButton(color: AppColors.white),
      ),

      /// Body Section starts here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const CommonText(
                  text: AppString.otpVerification,
                  fontSize: 30,
                  bottom: 20,
                  color: AppColors.white,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        /// instruction how to get OTP
                        CommonImage(
                          imageSrc: AppImages.onboarding,
                          height: 297,
                          width: 297,
                        ),
                        Center(
                          child: CommonText(
                            text:
                            "OTP Code has been sent to your registered email",
                            fontSize: 18,
                            top: 10,
                            bottom: 20,
                            maxLines: 3,
                          ),
                        ),

                        /// OTP Field here
                        Flexible(
                          flex: 0,
                          child: PinCodeTextField(
                            controller: controller.otpController,
                            autoDisposeControllers: false,
                            cursorColor: AppColors.primaryColor,
                            appContext: (context),
                            autoFocus: true,
                            length: 4,
                            keyboardType: TextInputType.number,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableActiveFill: true,
                            enablePinAutofill: true,
                            useHapticFeedback: true,
                            mainAxisAlignment: MainAxisAlignment.center,

                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12.r),
                              fieldHeight: 50.h,
                              fieldWidth: 55.w,
                              fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10.w),
                              activeFillColor: AppColors.transparent,
                              selectedFillColor: AppColors.transparent,
                              inactiveFillColor: AppColors.transparent,
                              borderWidth: 0.5.w,
                              selectedColor: AppColors.primaryColor,
                              activeColor: AppColors.primaryColor,
                              inactiveColor: AppColors.black,
                            ),

                            validator: (value) {
                              if (value != null && value.length == 4) {
                                return null;
                              } else {
                                return "Please enter a 4-digit code";
                              }
                            },
                            onChanged: (value) {
                              // Logic for value change
                            },
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// Resend OTP or show Timer
                        GestureDetector(
                          onTap: controller.time == '00:00' && !controller.isLoadingResend
                              ? () {
                            controller.resendOtpRepo();
                          }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (controller.time != '00:00') ...[
                                CommonText(
                                  text: "Resend code in ",
                                  fontSize: 16.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                CommonText(
                                  text: controller.time,
                                  fontSize: 16.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ] else if (controller.isLoadingResend) ...[
                                SizedBox(
                                  width: 16.w,
                                  height: 16.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CommonText(
                                  text: "Resending...",
                                  fontSize: 16.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ] else ...[
                                CommonText(
                                  text: "Didn't get a code? ",
                                  fontSize: 16.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                CommonText(
                                  text: "Resend",
                                  fontSize: 16.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

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
              ],
            ),
          );
        },
      ),
    );
  }
}