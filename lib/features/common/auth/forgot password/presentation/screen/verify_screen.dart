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
      body: SingleChildScrollView(
        child: Column(
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
                              autoDisposeControllers: false,
                              cursorColor: AppColors.primaryColor,
                              appContext: (context),
                              autoFocus: true,
                              // Change length to 4
                              length: 4,
                              keyboardType: TextInputType.number,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              enableActiveFill: true,

                              // Center the fields
                              mainAxisAlignment: MainAxisAlignment.center,

                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(12.r),
                                fieldHeight: 50.h,
                                // You can increase fieldWidth slightly for 4 boxes
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
                                // Update validation to check for 4 digits
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
