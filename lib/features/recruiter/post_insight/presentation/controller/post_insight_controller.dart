import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';

class PostInsightController extends GetxController {
  // Observable properties
  final RxString selectedPostId = ''.obs; // Use ID instead of title
  final RxString selectedTimePeriod = 'Last 30 Days'.obs;

  final RxList<Map<String, dynamic>> recentApplicants = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recentQualified = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, String>> jobTitlesList = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;

  // Time period options
  final List<String> timePeriods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'Last Year',
  ];

  // Stats
  final RxInt applicationCount = 0.obs;
  final RxInt qualifiedCount = 0.obs;
  final RxString engagementRate = '0%'.obs;
  final RxInt rejectCount = 0.obs;

  // Get list of post IDs for dropdown
  List<String> get postIds => jobTitlesList
      .map((e) => e['id'] ?? '')
      .where((id) => id.isNotEmpty)
      .toList();

  // Get title for a given post ID
  String getTitleForId(String id) {
    final post = jobTitlesList.firstWhere(
          (post) => post['id'] == id,
      orElse: () => {'id': '', 'title': ''},
    );
    return post['title'] ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getPosts();
    if (jobTitlesList.isNotEmpty) {
      selectedPostId.value = jobTitlesList[0]['id'] ?? '';
      await getPostInsight();
    }
  }

  Future<void> getPosts() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(ApiEndPoint.job_all);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> posts = data['data'];

          jobTitlesList.value = posts.map((post) {
            return {
              'id': (post['_id'] as String?) ?? '',
              'title': (post['title'] as String?)?.trim() ?? '',
            };
          }).toList();

          // Filter out any entries with empty id or title
          jobTitlesList.removeWhere((post) =>
          post['id']?.isEmpty ?? true || post['title']!.isEmpty ?? true
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch posts: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPostInsight() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get("job-post/insights/${selectedPostId.value}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          final insightData = data['data'];

          // Update summary stats
          final summary = insightData['summary'];
          applicationCount.value = summary['total'] ?? 0;
          qualifiedCount.value = summary['qualified'] ?? 0;
          rejectCount.value = summary['rejected'] ?? 0;
          engagementRate.value = '${summary['engaged'] ?? 0}%';

          // Update recent applicants
          final List<dynamic> recentApps = insightData['recentApplications'] ?? [];
          recentApplicants.value = recentApps.map((app) {
            final user = app['user'];
            return {
              'id': app['_id'],
              'name': user['name'] ?? '',
              'jobTitle': user['designation'] ?? '',
              'matchPercentage': app['jobMatch'] ?? 0,
              'profileImage': user['image'] ?? '',
              'status': app['status'] ?? '',
            };
          }).toList();

          // Update recent qualified
          final List<dynamic> qualifiedApps = insightData['recentQualifiedApplications'] ?? [];
          recentQualified.value = qualifiedApps.map((app) {
            final user = app['user'];
            return {
              'id': app['_id'],
              'name': user['name'] ?? '',
              'jobTitle': user['designation'] ?? '',
              'matchPercentage': app['jobMatch'] ?? 0,
              'profileImage': user['image'] ?? '',
              'status': app['status'] ?? '',
            };
          }).toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch insights: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPostId(String postId) {
    selectedPostId.value = postId;
    getPostInsight();
  }

  void selectTimePeriod(String period) {
    selectedTimePeriod.value = period;
    // Reload data based on selected period if needed
  }

  void viewApplicantProfile(String applicantId) {

  }
}