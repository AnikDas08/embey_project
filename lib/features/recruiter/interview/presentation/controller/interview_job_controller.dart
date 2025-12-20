import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/component/pop_up/interview_schedule_popup.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../data/model/interview_model.dart';
import '../screen/complete_interview_details_screen.dart';
import '../screen/upcoming_interview_details_screen.dart';

class InterviewJobController extends GetxController {
  // ================== UI STATES ==================
  final RxInt selectedTabIndex = 0.obs;
  final RxInt selectedDateIndex = 0.obs;
  final RxString selectedMonth = ''.obs;
  final RxString selectedDate = ''.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<InterviewData> interviews = <InterviewData>[].obs;

  final RxList<Map<String, dynamic>> dates = <Map<String, dynamic>>[].obs;

  // ================== FORM CONTROLLERS (LIKE RESUME) ==================
  final TextEditingController interviewDate = TextEditingController();
  final TextEditingController interviewTime = TextEditingController();
  final TextEditingController interviewNote = TextEditingController();
  final RxString interviewType = 'remote'.obs;

  String interviewId = '';

  // ================== LIFECYCLE ==================
  @override
  void onInit() {
    super.onInit();
    _initializeDates();
    _selectTodayDate();
    fetchInterviews();
  }

  @override
  void onClose() {
    interviewDate.dispose();
    interviewTime.dispose();
    interviewNote.dispose();
    super.onClose();
  }

  // ================== DATE SETUP ==================
  void _initializeDates() {
    final now = DateTime.now();
    dates.clear();

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      dates.add({
        'day': DateFormat('EEE').format(date),
        'date': DateFormat('dd').format(date),
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
      });
    }

    selectedMonth.value = DateFormat('MMMM yyyy').format(now);
  }

  void _selectTodayDate() {
    final today = DateFormat('dd').format(DateTime.now());
    final index = dates.indexWhere((d) => d['date'] == today);

    selectedDateIndex.value = index != -1 ? index : 0;
    selectedDate.value = dates[selectedDateIndex.value]['fullDate'];
  }

  // ================== API ==================
  Future<void> fetchInterviews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final interviewType =
      selectedTabIndex.value == 0 ? 'upcomming' : 'complete';

      final url =
          '/application?status=INTERVIEW&interview_type=$interviewType&interview_date=${selectedDate.value}';

      final response = await ApiService.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = InterviewResponse.fromJson(response.data);
        interviews.assignAll(result.data);
      } else {
        throw Exception('Failed to load interviews');
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ================== TAB & DATE ==================
  void selectTab(int index) {
    if (selectedTabIndex.value != index) {
      selectedTabIndex.value = index;
      fetchInterviews();
    }
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedDate.value = dates[index]['fullDate'];
    fetchInterviews();
  }

  List<InterviewData> get currentInterviews => interviews;

  // ================== CARD DATA ==================
  Map<String, dynamic> getInterviewCardData(InterviewData interview) {
    String scheduleTime;
    try {
      final date =
      DateFormat('dd MMM yyyy').format(DateTime.parse(interview.interviewDetails.date));
      scheduleTime =
      'Schedule: $date At ${interview.interviewDetails.time}';
    } catch (_) {
      scheduleTime = interview.interviewDetails.time;
    }

    return {
      'name': interview.user.name,
      'jobTitle': interview.title,
      'experience': interview.yearOfExperience,
      'scheduleTime': scheduleTime,
      'profileImage': interview.user.image,
    };
  }

  // ================== EDIT INTERVIEW ==================
  void editInterview(String id) {
    final interview = interviews.firstWhere((e) => e.id == id);
    interviewId = id;

    final apiDate = DateFormat('dd MMM yyyy')
        .format(DateTime.parse(interview.interviewDetails.date));
    final apiTime = interview.interviewDetails.time;
    final apiType = interview.interviewDetails.interviewType.capitalizeFirst ?? 'Onsite';


    // Set the controller values (optional, if you want to reuse)
    interviewDate.text = apiDate;
    interviewTime.text = apiTime;
    interviewType.value = apiType;

    showDialog(
      context: Get.context!,
      builder: (_) => InterviewSchedulePopup(
        initialDate: apiDate,
        initialTime: apiTime,
        initialInterviewType: apiType,
        onSubmit: (date, time, type, note) {
          interviewDate.text = date;
          interviewTime.text = time;
          interviewType.value = type.toLowerCase();

          scheduleInterview(); // ✅ SAME FLOW
        },
      ),
    );
  }


  // ================== SCHEDULE / UPDATE ==================
  void scheduleInterview() async {
    try {
      isLoading.value = true;

      final response = await ApiService.patch(
        '/application/interview-change-time/$interviewId',
        body: {

            "date": _formatDateForApi(interviewDate.text),
            "time": interviewTime.text,
            "interview_type": interviewType.value,
        },
      );

      if (response.statusCode == 200) {
        Get.back();
        fetchInterviews();
        Get.snackbar("Success", "Interview scheduled successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to schedule interview");
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDateForApi(String dateText) {
    try {
      final date = DateFormat('dd MMM yyyy').parse(dateText);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (_) {
      return dateText;
    }
  }

  // ================== DETAILS ==================
  void viewCandidateProfile(String id) {
    final interview = interviews.firstWhere((e) => e.id == id);
    final isCompleted = selectedTabIndex.value == 1;
    print("Id is : $id");
    Get.to( () => isCompleted ? CompleteInterviewDetailsScreen()
        :UpcomingInterviewDetailsScreen(),arguments: id);

  }

  Future<void> refreshInterviews() async => fetchInterviews();
}
