import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/socket/socket_service.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/utils/enum/enum.dart';

class RecruiterChatController extends GetxController {
  /// Api status
  Status status = Status.completed;

  /// Load more indicator
  bool isMoreLoading = false;

  /// Search controller
  TextEditingController searchController = TextEditingController();

  /// Page number
  int page = 1;

  /// Chat list
  List<ChatModel> chats = [];

  /// Scroll controller
  ScrollController scrollController = ScrollController();

  /// Search term
  String searchTerm = '';

  /// Instance
  static RecruiterChatController get instance =>
      Get.put(RecruiterChatController());

  /* ================= SEARCH ================= */

  /// Search using API with searchTerm parameter
  Timer? _debounce;

  void searchByName(String query) {
    searchTerm = query;
    page = 1;

    // Cancel previous debounce timer if typing continues
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      getChatRepo();
    });
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    searchTerm = '';
    page = 1;
    getChatRepo();
  }

  /* ================= PAGINATION ================= */

  void moreChats() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isMoreLoading) return;

      isMoreLoading = true;
      update();

      await getChatRepo(isLoadMore: true);

      isMoreLoading = false;
      update();
    }
  }

  /* ================= API ================= */

  Future<void> getChatRepo({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      status = Status.loading;
      update();
    }

    // Build URL with search term if present
    String url = "${ApiEndPoint.chat}?page=$page";
    if (searchTerm.isNotEmpty) {
      url += "&searchTerm=$searchTerm";
    }

    final response = await ApiService.get(url);

    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? [];

      if (!isLoadMore) {
        chats.clear();
        page = 1;
      }

      final newChats = data.map((e) => ChatModel.fromJson(e)).toList();
      chats.addAll(newChats);

      page++;
      status = Status.completed;
      update();
    } else {
      status = Status.error;
      Utils.errorSnackBar(
        response.statusCode.toString(),
        response.message,
      );
      update();
    }
  }

  /* ================= SOCKET ================= */

  void listenChat() {
    SocketServices.on(
      "update-chatlist::${LocalStorage.userId}",
          (data) {
        // Only update if not searching
        if (searchTerm.isEmpty) {
          page = 1;
          chats.clear();

          for (var item in data) {
            chats.add(ChatModel.fromJson(item));
          }

          status = Status.completed;
          update();
        }
      },
    );
  }

  /* ================= LIFECYCLE ================= */

  @override
  void onInit() {
    super.onInit();
    getChatRepo();
    listenChat();
    scrollController.addListener(moreChats);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}