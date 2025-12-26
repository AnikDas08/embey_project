import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/utils/app_utils.dart';
import 'package:embeyi/features/recruiter/message/presentation/screen/recruiter_chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

import '../../../../../core/config/route/recruiter_routes.dart';
import '../../../../../core/services/api/api_service.dart';

class RecruiterResumeController extends GetxController {

  final RxBool isLoading = false.obs;
  final RxString resumeUrl = ''.obs;
  final RxString applicationId = ''.obs;
  final RxString applicationStatus = ''.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  String candidateId="";

  // Button visibility flags
  final RxBool showShortlistButton = false.obs;
  final RxBool showInterviewButton = false.obs;
  final RxBool showRejectButton = false.obs;

  // Form controllers
  TextEditingController rejectReason = TextEditingController();
  TextEditingController interviewDate = TextEditingController();
  TextEditingController interviewTime = TextEditingController();
  TextEditingController interviewNote = TextEditingController();
  final RxString interviewType = 'remote'.obs; // 'remote' or 'onsite'

  @override
  void onInit() {
    super.onInit();
    // Get the application ID from arguments
    final id = Get.arguments["applicationId"];
    applicationId.value = id;
    print("applicationId: $applicationId");
    fetchApplicationDetails();
  }

  @override
  void onClose() {
    rejectReason.dispose();
    interviewDate.dispose();
    interviewTime.dispose();
    interviewNote.dispose();
    super.onClose();
  }

  Future<void> fetchApplicationDetails() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        'application/${applicationId.value}',
      );

      if (response.statusCode == 200) {
        final data = response.data["data"];

        candidateId=data["user"]["_id"];
        print("candidateId: $candidateId");

        // Get resume
        final resume = data["resume"];
        print("resume: $resume");
        if (resume != null && resume.isNotEmpty) {
          // Construct full URL - adjust base URL as needed
          resumeUrl.value = resume.startsWith('http')
              ? resume
              : '${ApiEndPoint.imageUrl}$resume';
          print("Full resume URL: ${resumeUrl.value}");
        }

        // Get status and update button visibility
        final status = data["status"]?.toString().toUpperCase() ?? '';
        applicationStatus.value = status;
        print("Application Status: $status");
        updateButtonVisibility(status);
      }
    } catch (e) {
      print("Error fetching application details: $e");
      Utils.errorSnackBar("Error", "Failed to fetch resume: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void shortlistJob() async {
    try {
      final response = await ApiService.patch(
        'application/${applicationId.value}',
        body: {
          "status": "SHORTLISTED",
        },
      );
      if (response.statusCode == 200) {
        Get.back();
        Utils.successSnackBar("Success", "Application Shortlisted");
        // Refresh the data
        fetchApplicationDetails();
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to shortlist application");
    }
  }

  void rejectJob() async {
    if (rejectReason.text.trim().isEmpty) {
      Utils.errorSnackBar("Error", "Please provide a reason for rejection");
      return;
    }

    try {
      final response = await ApiService.patch(
        'application/${applicationId.value}',
        body: {
          "status": "REJECTED",
          "rejectedReason": rejectReason.text.trim()
        },
      );
      if (response.statusCode == 200) {
        Get.back(); // Close dialog
        Get.back(); // Go back to previous screen
        Utils.successSnackBar("Success", "Application Rejected");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to reject application");
    }
  }

  void scheduleInterview() async {
    // Validate inputs
    if (interviewDate.text.trim().isEmpty) {
      Utils.errorSnackBar("Error", "Please select interview date");
      return;
    }
    if (interviewTime.text.trim().isEmpty) {
      Utils.errorSnackBar("Error", "Please select interview time");
      return;
    }

    try {
      final response = await ApiService.patch(
        'application/${applicationId.value}',
        body: {
          "status": "INTERVIEW",
          "interviewDetails": {
            "date": formatDateForApi(interviewDate.text),
            "time": interviewTime.text.trim(),
            "interview_type": interviewType.value.toLowerCase(),
          }
        },
      );
      if (response.statusCode == 200) {
        Get.back(); // Close dialog
        Utils.successSnackBar("Success", "Interview Scheduled Successfully");
        // Clear form
        clearInterviewForm();
        // Refresh the data
        fetchApplicationDetails();
      }
      else{
        Utils.errorSnackBar("Error", response.data["message"].toString());
      }
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    }
  }

  String formatDateForApi(String dateText) {
    // Convert "01 Oct 2025" to "2025-10-01"
    try {
      final parts = dateText.split(' ');
      if (parts.length == 3) {
        final day = parts[0];
        final month = parts[1];
        final year = parts[2];

        const months = {
          'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
          'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
          'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
        };

        final monthNum = months[month] ?? '01';
        return '$year-$monthNum-${day.padLeft(2, '0')}';
      }
    } catch (e) {
      print("Date format error: $e");
    }
    return dateText;
  }

  void clearInterviewForm() {
    interviewDate.clear();
    interviewTime.clear();
    interviewNote.clear();
    interviewType.value = 'remote';
  }

  void updateButtonVisibility(String status) {
    // Reset all buttons
    showShortlistButton.value = false;
    showInterviewButton.value = false;
    showRejectButton.value = false;

    switch (status) {
      case 'PENDING':
      // Show all three buttons
        showShortlistButton.value = true;
        showInterviewButton.value = true;
        showRejectButton.value = true;
        break;

      case 'SHORTLISTED':
      // Show only Interview and Reject buttons
        showInterviewButton.value = true;
        showRejectButton.value = true;
        break;

      case 'INTERVIEW':
      // Show only Reject button
        showRejectButton.value = true;
        break;

      case 'REJECTED':
      // Don't show any buttons
        break;

      default:
      // For any other status, show all buttons as fallback
        showShortlistButton.value = true;
        showInterviewButton.value = true;
        showRejectButton.value = true;
        break;
    }
  }

  Future<void> downloadResume() async {
    if (resumeUrl.value.isEmpty) {
      Utils.errorSnackBar("Error", "No resume available to download");
      return;
    }

    try {
      print("📥 Starting download for: ${resumeUrl.value}");

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
      final dio = Dio();
      await dio.download(
        resumeUrl.value,
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

        // Automatically open the file with system file opener
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

  Future<void> goToChat() async {
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