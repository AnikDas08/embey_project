// complete_interview_details_controller.dart

import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/core/utils/app_utils.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

import '../../../message/presentation/screen/recruiter_chat_screen.dart';
import '../../data/model/interview_details.dart';

class CompleteInterviewDetailsController extends GetxController {
  final Dio _dio = Dio();

  final isLoading = false.obs;
  final applicationData = Rxn<ApplicationData>();
  final errorMessage = ''.obs;
  final isDownloading = false.obs;
  final downloadProgress = 0.0.obs;

  String? applicationId;
  String candidateId = "";

  @override
  void onInit() {
    super.onInit();
    // Get application ID from arguments
    if (Get.arguments != null) {
      applicationId = Get.arguments;
      print("Application ID: $applicationId");
      fetchApplicationDetails();
    }
  }

  Future<void> fetchApplicationDetails() async {
    if (applicationId == null) {
      errorMessage.value = 'Application ID is missing';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.get(
        "application/$applicationId?interview_type=complete&status=INTERVIEW",
      );

      if (response.statusCode == 200) {
        final model = ApplicationInterview.fromJson(response.data);
        if (model.success) {
          applicationData.value = model.data;
          candidateId = model.data.user.id;
          print("✅ Application data loaded successfully");
        } else {
          errorMessage.value = model.message;
        }
      } else {
        errorMessage.value = 'Failed to fetch application details';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        errorMessage.value = e.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage.value = 'Network error. Please check your connection';
      }
    } catch (e) {
      print("❌ Error fetching application: $e");
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadResume() async {
    if (applicationData.value?.resume == null || applicationData.value!.resume.isEmpty) {
      Utils.errorSnackBar("Error", "No resume available to download");
      return;
    }

    try {
      print("📥 Starting download for resume");

      // Request permissions
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (status.isDenied) {
          status = await Permission.manageExternalStorage.request();
        }

        if (status.isDenied || status.isPermanentlyDenied) {
          Utils.errorSnackBar(
            "Permission Denied",
            "Please enable storage permission in settings",
          );
          return;
        }
      }

      isDownloading.value = true;
      downloadProgress.value = 0.0;

      // Construct full resume URL
      String resumeUrl = applicationData.value!.resume;
      if (!resumeUrl.startsWith('http')) {
        resumeUrl = ApiEndPoint.imageUrl + resumeUrl;
      }

      print("📄 Resume URL: $resumeUrl");

      // Get download directory
      Directory? directory;
      String savePath;

      if (Platform.isAndroid) {
        // Save to Downloads folder
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Generate unique filename
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'Resume_$timestamp.pdf';
        savePath = '${directory.path}/$fileName';
      } else {
        // iOS - save to app documents
        directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'Resume_$timestamp.pdf';
        savePath = '${directory.path}/$fileName';
      }

      print("💾 Saving to: $savePath");

      // Download file
      await _dio.download(
        resumeUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
            print("📊 Progress: ${(downloadProgress.value * 100).toStringAsFixed(0)}%");
          }
        },
      );

      print("✅ Download complete!");

      // Verify file exists
      final file = File(savePath);
      if (await file.exists()) {
        final fileSize = await file.length();
        print("📄 File size: ${(fileSize / 1024).toStringAsFixed(2)} KB");

        // Show success message
        Utils.successSnackBar(
            "Success",
            "Resume downloaded successfully!"
        );

        // Automatically open the file
        final result = await OpenFile.open(savePath);
        print("Open file result: ${result.message}");

        if (result.type != ResultType.done) {
          Utils.errorSnackBar("Error", "Could not open file: ${result.message}");
        }
      } else {
        throw Exception("File was not saved properly");
      }

    } catch (e) {
      print("❌ Download error: $e");
      Utils.errorSnackBar("Download Failed", e.toString());
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  String getFormattedSalary() {
    if (applicationData.value == null) return '';
    final minSalary = applicationData.value!.post.minSalary;
    final maxSalary = applicationData.value!.post.maxSalary;
    return '\$${minSalary} - \$${maxSalary}';
  }

  String getJobTypeLabel(String jobType) {
    switch (jobType.toUpperCase()) {
      case 'FULL_TIME':
        return 'Full Time';
      case 'PART_TIME':
        return 'Part Time';
      case 'CONTRACT':
        return 'Contract';
      case 'REMOTE':
        return 'Remote';
      default:
        return jobType;
    }
  }

  String getJobLevelLabel(String jobLevel) {
    switch (jobLevel.toUpperCase()) {
      case 'ENTRY_LEVEL':
        return 'Entry Level';
      case 'MID_LEVEL':
        return 'Mid Level';
      case 'SENIOR_LEVEL':
        return 'Senior Level';
      default:
        return jobLevel;
    }
  }

  String getInterviewTypeLabel(String? interviewType) {
    if (interviewType == null) return 'On Site';
    switch (interviewType.toLowerCase()) {
      case 'remote':
        return 'Remote';
      case 'onsite':
        return 'On Site';
      case 'hybrid':
        return 'Hybrid';
      default:
        return interviewType;
    }
  }

  String getFormattedDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String getPostedInfo() {
    if (applicationData.value == null) return '';
    try {
      final createdDate = DateTime.parse(applicationData.value!.createdAt);
      final deadline = DateTime.parse(applicationData.value!.post.deadline);
      final now = DateTime.now();
      final difference = now.difference(createdDate).inDays;

      final deadlineFormatted = getFormattedDate(applicationData.value!.post.deadline);

      return 'Posted $difference Days Ago, End Date $deadlineFormatted';
    } catch (e) {
      return '';
    }
  }

  Future<void> onMessageTap() async {
    if (candidateId.isEmpty) {
      Utils.errorSnackBar("Error", "Candidate information not found");
      return;
    }

    try {
      print("💬 Initiating chat with candidate: $candidateId");

      final response = await ApiService.post(
        'chat/$candidateId',
        body: {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Chat created successfully");
        Get.to(() => RecruiterChatListScreen());
      } else {
        print("❌ Chat API failed: ${response.statusCode}");
        Utils.errorSnackBar("Error", "Could not initiate chat");
      }
    } catch (e) {
      print("❌ Chat error: $e");
      Utils.errorSnackBar("Error", "Could not initiate chat");
    }
  }
}