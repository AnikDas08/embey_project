import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/favourite_model.dart';

class FavouriteController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isRemoving = false.obs;
  final RxBool isToggling = false.obs;

  // Favourite list
  final RxList<FavouriteItem> favouriteList = <FavouriteItem>[].obs;

  // Pagination
  final Rx<Pagination?> pagination = Rx<Pagination?>(null);

  // Track ongoing toggle operations to prevent duplicates
  final RxSet<String> togglingIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getFavourites();
  }

  /// Get Favourites from API
  Future<void> getFavourites({int page = 1}) async {
    // Show loading only on first page
    if (page == 1) {
      isLoading.value = true;
    }

    try {
      final token = LocalStorage.token;
      if (token == null || token.isEmpty) {
        Utils.errorSnackBar(0, "Token not found, please login again");
        return;
      }

      final response = await ApiService.get(
        ApiEndPoint.favourite,
        header: {"Authorization": "Bearer $token"},
      );

      print("============ GET FAVOURITES ============");
      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final favouriteResponse = FavouriteResponse.fromJson(response.data);

        if (page == 1) {
          // Replace list on first page
          favouriteList.value = favouriteResponse.data;
        } else {
          // Append to list on subsequent pages
          favouriteList.addAll(favouriteResponse.data);
        }

        pagination.value = favouriteResponse.pagination;

        print("✅ Loaded ${favouriteList.length} favourites");
      } else {
        Utils.errorSnackBar(
          response.statusCode ?? 0,
          response.message ?? "Failed to load favourites",
        );
      }
    } catch (e) {
      print("❌ Error fetching favourites: $e");
      Utils.errorSnackBar(0, "Failed to load favourites: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove from Favourites
  Future<void> removeFavourite(String favouriteId, int index) async {
    try {
      final token = LocalStorage.token;
      if (token == null || token.isEmpty) {
        Utils.errorSnackBar(0, "Token not found, please login again");
        return;
      }

      isRemoving.value = true;

      // Call your remove API endpoint
      final response = await ApiService.delete(
        "${ApiEndPoint.favourite}/$favouriteId",
        header: {"Authorization": "Bearer $token"},
      );

      print("============ REMOVE FAVOURITE ============");
      print("Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Remove from local list
        favouriteList.removeAt(index);

        Utils.successSnackBar("Success", "Removed from favourites");

        print("✅ Favourite removed successfully");
      } else {
        Utils.errorSnackBar(
          response.statusCode ?? 0,
          response.message ?? "Failed to remove favourite",
        );
      }
    } catch (e) {
      print("❌ Error removing favourite: $e");
      Utils.errorSnackBar(0, "Failed to remove: ${e.toString()}");
    } finally {
      isRemoving.value = false;
    }
  }

  /// Toggle Favorite (Add/Remove) with optimistic update
  Future<void> toggleFavorite(String postId) async {
    if (postId.isEmpty) {
      print("❌ Error: Post ID is empty");
      return;
    }

    // Prevent duplicate requests for the same post
    if (togglingIds.contains(postId)) {
      print("⚠️ Toggle already in progress for post: $postId");
      return;
    }

    try {
      final token = LocalStorage.token;
      if (token == null || token.isEmpty) {
        Utils.errorSnackBar(0, "Token not found, please login again");
        return;
      }

      // Mark as toggling
      togglingIds.add(postId);
      isToggling.value = true;

      // Check if currently in favorites
      final currentIndex = favouriteList.indexWhere((item) => item.post.id == postId);
      final isCurrentlyFavorite = currentIndex != -1;

      // Store the item for potential rollback
      FavouriteItem? removedItem;
      int? removedIndex;

      // Optimistic Update: Update UI immediately
      if (isCurrentlyFavorite) {
        // Remove from list optimistically
        removedItem = favouriteList[currentIndex];
        removedIndex = currentIndex;
        favouriteList.removeAt(currentIndex);
      }

      print("============ TOGGLE FAVOURITE ============");
      print("Post ID: $postId");
      print("Currently Favorite: $isCurrentlyFavorite");

      // API Call
      final response = await ApiService.post(
        ApiEndPoint.favourite,
        body: {"post": postId},
        header: {"Authorization": "Bearer $token"},
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Success
        if (isCurrentlyFavorite) {
          Utils.successSnackBar("Success", "Removed from favourites");
          print("✅ Removed from favourites");
        } else {
          // Add the new favorite to the list
          if (response.data != null && response.data['data'] != null) {
            final newFavorite = FavouriteItem.fromJson(response.data['data']);
            favouriteList.insert(0, newFavorite);
          }
          Utils.successSnackBar("Success", "Added to favourites");
          print("✅ Added to favourites");
        }
      } else {
        // API Failed: Rollback optimistic update
        print("❌ API Error: ${response.message}");

        if (isCurrentlyFavorite && removedItem != null && removedIndex != null) {
          // Restore removed item
          favouriteList.insert(removedIndex, removedItem);
        }

        Utils.errorSnackBar(
          response.statusCode ?? 0,
          response.message ?? "Failed to toggle favourite",
        );
      }
    } catch (e) {
      print("❌ Exception toggling favourite: $e");

      // On exception, refresh the list to ensure consistency
      await getFavourites(page: 1);

      Utils.errorSnackBar(0, "Failed to toggle favourite: ${e.toString()}");
    } finally {
      togglingIds.remove(postId);
      isToggling.value = togglingIds.isNotEmpty;
    }
  }

  /// Refresh favourites
  Future<void> refreshFavourites() async {
    await getFavourites(page: 1);
  }

  /// Load more favourites (for pagination)
  Future<void> loadMoreFavourites() async {
    if (pagination.value != null &&
        pagination.value!.page < pagination.value!.totalPage) {
      await getFavourites(page: pagination.value!.page + 1);
    }
  }

  /// Check if item is in favourites
  bool isFavourite(String postId) {
    return favouriteList.any((item) => item.post.id == postId);
  }

  /// Get favourite item by post ID
  FavouriteItem? getFavouriteByPostId(String postId) {
    try {
      return favouriteList.firstWhere((item) => item.post.id == postId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a post is currently being toggled
  bool isTogglingPost(String postId) {
    return togglingIds.contains(postId);
  }
}