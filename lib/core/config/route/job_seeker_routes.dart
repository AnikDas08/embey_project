import 'package:embeyi/features/job_seeker/history/presentation/screen/history_screen.dart';
import 'package:embeyi/features/job_seeker/history/presentation/screen/applied_details.dart';
import 'package:embeyi/features/job_seeker/home/presentation/screen/all_job_category_screen.dart';
import 'package:embeyi/features/job_seeker/home/presentation/screen/all_recommended_job_screen.dart';
import 'package:embeyi/features/job_seeker/home/presentation/screen/category_details.dart';
import 'package:embeyi/features/job_seeker/home/presentation/screen/category_job_list_screen.dart';
import 'package:embeyi/features/job_seeker/home/presentation/screen/job_seeker_home_screen.dart';
import 'package:embeyi/features/job_seeker/jobs/presentation/screen/jobs_screen.dart';
import 'package:embeyi/features/job_seeker/jobs/presentation/screen/job_details_screen.dart';
import 'package:embeyi/features/job_seeker/jobs/presentation/screen/company_overview_screen.dart';
import 'package:embeyi/features/job_seeker/jobs/presentation/screen/webview_screen_here.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/payment_history_screen.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/profile/add_education_screen.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/profile/add_work_experience_screen.dart';
import 'package:get/get.dart';

// Job Seeker imports
import '../../../features/job_seeker/message/presentation/screen/job_seeker_chat_screen.dart';
import '../../../features/job_seeker/message/presentation/screen/message_screen.dart';
import '../../../features/job_seeker/notifications/presentation/screen/job_seeker_notifications_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/job_seeker_profile_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/edit_profile.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/personal_info_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/education_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/work_experience_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/skills_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/edit_personal_info_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/edit_education_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/edit_work_experience_screen.dart';
import '../../../features/job_seeker/profile/presentation/screen/profile/edit_skills_screen.dart';
import '../../../features/job_seeker/setting/presentation/screen/job_seeker_privacy_policy_screen.dart';
import '../../../features/job_seeker/setting/presentation/screen/job_seeker_help_support_screen.dart';
import '../../../features/job_seeker/setting/presentation/screen/job_seeker_setting_screen.dart';
import '../../../features/job_seeker/setting/presentation/screen/job_seeker_terms_of_services_screen.dart';

class JobSeekerRoutes {
  // Job Seeker Route Constants
  static const String home = "/job_seeker_home_screen.dart";
  static const String notifications = "/job_seeker_notifications_screen.dart";
  static const String chat = "/job_seeker_chat_screen.dart";
  static const String message = "/message_screen.dart";
  static const String profile = "/job_seeker_profile_screen.dart";
  static const String editProfile = "/edit_profile.dart";
  static const String privacyPolicy = "/job_seeker_privacy_policy_screen.dart";
  static const String termsOfServices =
      "/job_seeker_terms_of_services_screen.dart";
  static const String setting = "/job_seeker_setting_screen.dart";
  static const String jobs = "/job_seeker_jobs_screen.dart";
  static const String jobDetails = "/job_details_screen.dart";
  static const String jobWebView = "/jobWebView";
  static const String companyOverview = "/company_overview_screen.dart";
  static const String history = "/job_seeker_history_screen.dart";
  static const String appliedDetails = "/applied_details_screen.dart";
  static const String helpAndSupport = "/job_seeker_help_support_screen.dart";
  static const String myProfile = "/my_profile_screen.dart";
  static const String personalInfo = "/personal_info_screen.dart";
  static const String education = "/education_screen.dart";
  static const String workExperience = "/work_experience_screen.dart";
  static const String skills = "/skills_screen.dart";
  static const String editPersonalInfo = "/editPersonalInfo";
  static const String editEducation = "/edit_education_screen.dart";
  static const String editWorkExperience = "/edit_work_experience_screen.dart";
  static const String editSkills = "/edit_skills_screen.dart";
  static const String addEducation = "/add_education_screen.dart";
  static const String addWorkExperience = "/add_work_experience_screen.dart";
  static const String allRecommendedJob = "/all_recommended_job_screen.dart";
  static const String allJobCategory = "/all_job_category_screen.dart";
  static const String categoryJobList = "/category_job_list_screen.dart";
  static const String categoryDetails = "/categoryDetails.dart";
  static const String paymentHistoryScreenHere = "/paymentHistoryScreenHere";
  // Job Seeker Routes List
  static List<GetPage> routes = [
    GetPage(name: home, page: () => JobSeekerHomeScreen()),
    GetPage(
      name: notifications,
      page: () => const JobSeekerNotificationScreen(),
    ),
    GetPage(name: chat, page: () => const JobSeekerChatListScreen()),
    GetPage(name: message, page: () => const MessageScreen()),
    GetPage(name: profile, page: () => const JobSeekerProfileScreen()),
    GetPage(name: editProfile, page: () => JobSeekerEditProfile()),
    GetPage(
      name: privacyPolicy,
      page: () => const JobSeekerPrivacyPolicyScreen(),
    ),
    GetPage(
      name: termsOfServices,
      page: () => const JobSeekerTermsOfServicesScreen(),
    ),
    GetPage(
      name: helpAndSupport,
      page: () => const JobSeekerHelpSupportScreen(),
    ),
    GetPage(name: setting, page: () => const JobSeekerSettingScreen()),
    GetPage(name: jobWebView, page: () => const JobWebViewScreen()),
    GetPage(name: jobs, page: () => JobsScreen()),
    GetPage(name: jobDetails, page: () => const JobDetailsScreen()),
    GetPage(name: companyOverview, page: () => const CompanyOverviewScreen()),
    GetPage(name: history, page: () => HistoryScreen()),
    GetPage(
      name: appliedDetails,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>?;
        return AppliedDetails(
        );
      },
    ),
    GetPage(name: personalInfo, page: () => const PersonalInfoScreen()),
    GetPage(name: education, page: () => const EducationScreen()),
    GetPage(name: workExperience, page: () => const WorkExperienceScreen()),
    GetPage(name: skills, page: () => const SkillsScreen()),
    GetPage(name: editPersonalInfo, page: () => const EditPersonalInfoScreen()),
    GetPage(name: editEducation, page: () => const EditEducationScreen()),
    GetPage(
      name: editWorkExperience,
      page: () => EditWorkExperienceScreen(),
    ),
    GetPage(name: editSkills, page: () => const EditSkillsScreen()),
    GetPage(name: addEducation, page: () => const AddEducationScreen()),
    GetPage(
      name: addWorkExperience,
      page: () => const AddWorkExperienceScreen(),
    ),
    GetPage(
      name: allRecommendedJob,
      page: () => const AllRecommendedJobScreen(),
    ),
    GetPage(name: allJobCategory, page: () => const AllJobCategoryScreen()),
    GetPage(name: categoryDetails, page: () => CategoryDetails()),
    GetPage(
      name: categoryJobList,
      page: () => CategoryJobListScreen(category: Get.arguments),
    ),
    //GetPage(name: paymentHistoryScreenHere, page: () => const JobSeekerPaymentHistory(transactions: transactions)),
  ];

  // Job Seeker Navigation Helper Methods
  static void goToHome() => Get.toNamed(home);
  static void goToProfile() => Get.toNamed(profile);
  static void goToNotifications() => Get.toNamed(notifications);
  static void goToChat() => Get.toNamed(chat);
  static void goToSettings() => Get.toNamed(setting);
  static void goToPrivacyPolicy() => Get.toNamed(privacyPolicy);
  static void goToTermsOfServices() => Get.toNamed(termsOfServices);
  static void goToJobs() => Get.toNamed(jobs);
  static void goToJobDetails() => Get.toNamed(jobDetails);
  static void goToCompanyOverview() => Get.toNamed(companyOverview);
  static void goToHistory() => Get.toNamed(history);
  static void goToAppliedDetails() => Get.toNamed(appliedDetails);
  static void goToHelpAndSupport() => Get.toNamed(helpAndSupport);
  static void goToPersonalInfo() => Get.toNamed(personalInfo);
  static void goToEducation() => Get.toNamed(education);
  static void goToWorkExperience() => Get.toNamed(workExperience);
  static void goToSkills() => Get.toNamed(skills);
  static void goToEditPersonalInfo() => Get.toNamed(editPersonalInfo);
  static void goToEditEducation() => Get.toNamed(editEducation);
  static void goToEditWorkExperience() => Get.toNamed(editWorkExperience);
  static void goToEditSkills() => Get.toNamed(editSkills);
  static void goToAddEducation() => Get.toNamed(addEducation);
  static void goToAddWorkExperience() => Get.toNamed(addWorkExperience);
  static void goToAllRecommendedJob() => Get.toNamed(allRecommendedJob);
  static void goToAllJobCategory() => Get.toNamed(allJobCategory);
  static void goToCategoryJobList(String category) =>
      Get.toNamed(categoryJobList, arguments: category);
}
