import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import '../../../home/data/model/application_model.dart';

class PendingJobRequestController extends GetxController {
  // Observable properties - now using post ID as the value
  final RxString selectedPostId = 'all'.obs;

  final RxList<ApplicationData> applications = <ApplicationData>[].obs;
  final RxList<ApplicationData> filteredApplications = <ApplicationData>[].obs;
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingApplications = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await allPosts();      // Load posts first
    await pendingList();   // Then load applications
  }

  Future<void> pendingList() async {
    try {
      isLoading.value = true;
      isLoadingApplications.value = true;

      final response = await ApiService.get("application?status=PENDING");

      if (response.statusCode == 200) {
        final applicationModelList = ApplicationListModel.fromJson(response.data);

        if (applicationModelList.success) {
          applications.value = applicationModelList.data;
          filteredApplications.value = applicationModelList.data;

          print("✅ Applications loaded: ${applications.length}");

          if (applications.isNotEmpty) {
            print("📋 Sample application title: ${applications[0].title}");
          }
        }
      }
    } catch (e) {
      print("❌ Error loading applications: $e");
    } finally {
      isLoading.value = false;
      isLoadingApplications.value = false;
    }
  }

  /// Fetch all posts from API
  Future<void> allPosts() async {
    try {
      final response = await ApiService.get("job-post/feed/user");

      if (response.statusCode == 200) {
        var data = response.data['data'] as List;

        posts.assignAll(
            data.map((e) => {
              "id": e['_id'],
              "title": e['title'],
              "thumbnail": e['thumbnail'],
              "recruiter": e['recruiter'],
            }).toList()
        );

        print("✅ Posts loaded: ${posts.length}");
        print("📋 Available posts: ${posts.take(3).map((e) => e['title']).toList()}...");
      }
    } catch (e) {
      print("❌ Error loading posts: $e");
    }
  }

  /// Get post title by ID
  String getPostTitle(String postId) {
    if (postId == 'all') return 'All Posts';

    final post = posts.firstWhere(
          (p) => p['id'] == postId,
      orElse: () => {"title": "Unknown Post"},
    );
    return post['title'] as String;
  }

  /// Select post from dropdown
  void selectPost(String postId) {
    selectedPostId.value = postId;

    if (postId == 'all') {
      print("🔍 Selected: All Posts");
    } else {
      print("🔍 Selected: ${getPostTitle(postId)} (ID: $postId)");
    }

    _applyFilter();
  }

  /// Apply filter based on selected post
  void _applyFilter() {
    if (selectedPostId.value == 'all') {
      // Show all applications
      filteredApplications.value = applications;
      print("📊 Showing all: ${filteredApplications.length} applications");
    } else {
      // Filter by matching post title
      final selectedTitle = getPostTitle(selectedPostId.value);

      filteredApplications.value = applications.where((application) {
        return application.title == selectedTitle;
      }).toList();

      print("🔍 Filter: '$selectedTitle'");
      print("📊 Found: ${filteredApplications.length} applications");

      if (filteredApplications.isNotEmpty) {
        print("✅ Matched applications:");
        for (var app in filteredApplications.take(3)) {
          print("   - ${app.title}");
        }
      }
    }
  }

  int get totalRequestCount => filteredApplications.length;

  void viewCandidateProfile(String postId) {
    Get.toNamed(
      RecruiterRoutes.resume,
      arguments: {
        'applicationId': postId,
        'isShortlist': true,
        'isInterview': true,
        'isReject': true
      },
    );
  }
}