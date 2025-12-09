import 'package:embeyi/features/job_seeker/setting/presentation/controller/terms_of_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../../../core/component/other_widgets/common_loader.dart';
import '../../../../../core/component/screen/error_screen.dart';
import '../../../../../core/component/text/common_text.dart';
import '../controller/privacy_policy_controller.dart';
import '../../../../../core/utils/constants/app_string.dart';
import '../../../../../core/utils/enum/enum.dart';

class JobSeekerTermsOfServicesScreen extends StatelessWidget {
  const JobSeekerTermsOfServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.privacyPolicy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      /// Body
      body: GetBuilder<TermsOfServicesController>(
        builder: (controller) {
          switch (controller.status) {
            case Status.loading:
              return const CommonLoader();

            case Status.error:
              return ErrorScreen(
                onTap: () =>
                    TermsOfServicesController().getTermsOfServicesRepo(),
              );

            case Status.completed:
              if (controller.html == null) {
                return const Center(child: Text("No data found"));
              }
              return SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Html(data: controller.html!.data.content),
              );
          }
        },
      ),
    );
  }
}
