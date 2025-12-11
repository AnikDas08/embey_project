import 'package:flutter/material.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_phone_number_text_filed.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_string.dart';
import '../../../../../core/utils/helpers/other_helper.dart';
import '../../../../../core/utils/log/app_log.dart';
import '../presentation/controller/profile_controller.dart';

class EditProfileAllFiled extends StatelessWidget {
  const EditProfileAllFiled({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// User Full Name here
        const CommonText(
          text: AppString.fullName,
          fontWeight: FontWeight.w600,
          bottom: 12,
        ),
        CommonTextField(
          controller: controller.nameController,
          validator: OtherHelper.validator,
          hintText: AppString.fullName,
          prefixIcon: const Icon(Icons.person),
          keyboardType: TextInputType.text,
          borderColor: AppColors.black,
          fillColor: AppColors.transparent,
        ),

        /// User Phone number here
        const CommonText(
          text: AppString.contact,
          fontWeight: FontWeight.w600,
          top: 20,
          bottom: 12,
        ),
        CommonPhoneNumberTextFiled(
          controller: controller.numberController,
          countryChange: (value) {
            appLog(value);
          },
        ),
      ],
    );
  }
}
