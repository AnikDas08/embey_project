import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/socket/socket_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/utils/enum/enum.dart';
import '../../data/model/message_model.dart';

class RecruiterMessageController extends GetxController {
  // State variables
  Status status = Status.loading;
  bool isMoreLoading = false;
  bool isSending = false;
  bool isGeneratingZoomLink = false;

  // Data variables
  List<MessageModel> messages = [];
  String chatId = "";
  String name = "";
  String image = "";
  int page = 1;

  // Controllers
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  // File handling
  final ImagePicker _imagePicker = ImagePicker();
  List<File> selectedImages = [];
  List<File> selectedDocuments = [];

  /// Initializes the controller data and listeners
  void setupController() {
    chatId = Get.parameters['chatId'] ?? "";
    name = Get.parameters['name'] ?? "";
    image = Get.parameters['image'] ?? "";
    print("Chat ID: $chatId");
    print("Name: $name");
    print("Image: $image");

    if (chatId.isNotEmpty) {
      initChat();
    } else {
      status = Status.error;
      update();
      if (kDebugMode) print("Error: No Chat ID provided to MessageController");
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (!isMoreLoading && status == Status.completed) {
          getMessageRepo();
        }
      }
    });
  }

  /// Initial chat setup
  void initChat() {
    page = 1;
    messages.clear();
    status = Status.loading;
    update();

    getMessageRepo();
    listenMessage(chatId);
  }

  /// Fetch messages from API
  Future<void> getMessageRepo() async {
    if (page > 1) {
      isMoreLoading = true;
      update();
    }

    try {
      final response = await ApiService.get(
        "${ApiEndPoint.message}/$chatId?page=$page&limit=15",
      );

      if (response.statusCode == 200) {
        var responseData = response.data['data'] ?? {};
        var messagesList = responseData['messages'] ?? [];

        if (page == 1) {
          messages.clear();
        }

        List<MessageModel> newMessages = [];
        for (var messageData in messagesList) {
          newMessages.add(MessageModel.fromJson(messageData));
        }

        messages.addAll(newMessages);

        if (newMessages.isNotEmpty) {
          page++;
        }

        status = Status.completed;
      } else {
        status = page == 1 ? Status.error : Status.completed;
        Utils.errorSnackBar("Error ${response.statusCode}", response.message);
      }
    } catch (e) {
      status = Status.error;
      if (kDebugMode) print("API Error: $e");
    } finally {
      isMoreLoading = false;
      update();
    }
  }

  /// Socket Listener for real-time messages
  void listenMessage(String id) {
    SocketServices.on('getMessage::$id', (data) {
      try {
        MessageModel newMessage = MessageModel.fromJson(data);
        if (!messages.any((m) => m.id == newMessage.id)) {
          messages.insert(0, newMessage);
          update();
        }
      } catch (e) {
        if (kDebugMode) print("Error parsing socket message: $e");
      }
    });
  }

  /// Pick images from gallery
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages = images.map((xfile) => File(xfile.path)).toList();
        update();
      }
    } catch (e) {
      if (kDebugMode) print("Error picking images: $e");
      Utils.errorSnackBar("Error", "Failed to pick images");
    }
  }

  /// Pick documents
  Future<void> pickDocuments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'],
      );

      if (result != null) {
        selectedDocuments = result.paths.map((path) => File(path!)).toList();
        update();
      }
    } catch (e) {
      if (kDebugMode) print("Error picking documents: $e");
      Utils.errorSnackBar("Error", "Failed to pick documents");
    }
  }

  /// Remove selected image
  void removeImage(int index) {
    selectedImages.removeAt(index);
    update();
  }

  /// Remove selected document
  void removeDocument(int index) {
    selectedDocuments.removeAt(index);
    update();
  }

  /// Show attachment options
  void showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image, color: Colors.blue),
                title: Text('Image'),
                onTap: () {
                  Get.back();
                  pickImages();
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.orange),
                title: Text('Document'),
                onTap: () {
                  Get.back();
                  pickDocuments();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Generate and open Zoom link
  Future<void> generateAndOpenZoomLink() async {
    if (isGeneratingZoomLink) return;

    isGeneratingZoomLink = true;
    update();

    try {
      var body = {
        "chatId": chatId,
        "type": "zoom-link",
      };

      var response = await ApiService.post(
        "message",
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = response.data['data'];
        String zoomUrl = responseData['text'] ?? '';

        if (zoomUrl.isNotEmpty) {
          // Open zoom link in external browser
          await openZoomLinkInBrowser(zoomUrl);
        } else {
          Utils.errorSnackBar("Error", "No Zoom link received");
        }
      } else {
        Utils.errorSnackBar(
          "Error",
          response.message ?? "Failed to generate Zoom link",
        );
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to generate Zoom link: ${e.toString()}");
      if (kDebugMode) print("Generate Zoom link error: $e");
    } finally {
      isGeneratingZoomLink = false;
      update();
    }
  }

  /// Open Zoom link in external browser or Zoom app
  Future<void> openZoomLinkInBrowser(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        // Launch the URL in external browser
        // LaunchMode.externalApplication will open in default browser or Zoom app
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Utils.errorSnackBar("Error", "Cannot open Zoom link");
        if (kDebugMode) print("Cannot launch URL: $url");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to open Zoom link");
      if (kDebugMode) print("Launch URL error: $e");
    }
  }

  /// Open any URL in external browser
  Future<void> openUrl(String url) async {
    try {
      // Ensure URL has a scheme
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final Uri uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Utils.errorSnackBar("Error", "Cannot open URL");
        if (kDebugMode) print("Cannot launch URL: $url");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to open URL");
      if (kDebugMode) print("Launch URL error: $e");
    }
  }

  /// Open image in full screen
  void openImageFullScreen(String imageUrl) {
    Get.to(() => FullScreenImageViewer(imageUrl: imageUrl));
  }

  /// Send text message
  Future<void> sendTextMessage() async {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    var body = {
      "chatId": chatId,
      "text": text,
      "type": "text"
    };

    String messageText = messageController.text;
    messageController.clear();

    try {
      var response = await ApiService.post(
        "message",
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        messageController.text = messageText;
        Utils.errorSnackBar("Error", "Failed to send message");
      }
    } catch (e) {
      messageController.text = messageText;
      Utils.errorSnackBar("Error", "Failed to send message");
      if (kDebugMode) print("Send message error: $e");
    }
  }

  /// Send image message using multipartImage API
  Future<void> sendImageMessage() async {
    if (selectedImages.isEmpty) return;

    try {
      // Prepare the body with chat ID, type, and optional text
      Map<String, String> body = {
        'chatId': chatId,
        'type': 'image',
      };

      // Add text caption if provided
      if (messageController.text.isNotEmpty) {
        body['text'] = messageController.text;
        messageController.clear();
      }

      // Prepare files array for multipartImage
      List<Map<String, String>> files = [];
      for (var imageFile in selectedImages) {
        files.add({
          'name': 'image',
          'image': imageFile.path,
        });
      }

      // Call the multipartImage API
      var response = await ApiService.multipartImage(
        "message",
        body: body,
        files: files,
        method: "POST",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        selectedImages.clear();
        update();
      } else {
        Utils.errorSnackBar(
          "Error",
          response.message ?? "Failed to send image",
        );
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to send image: ${e.toString()}");
      if (kDebugMode) print("Send image error: $e");
    }
  }

  /// Download document to device
  Future<void> downloadDocument(String url, String fileName) async {
    try {
      // Show loading indicator
      //Utils.showLoadingDialog();

      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        // Launch the URL in external application (browser will handle download)
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        Get.back(); // Close loading dialog
        Utils.successSnackBar("Success", "Opening document...");
      } else {
        Get.back(); // Close loading dialog
        Utils.errorSnackBar("Error", "Cannot open document");
        if (kDebugMode) print("Cannot launch URL: $url");
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Utils.errorSnackBar("Error", "Failed to open document");
      if (kDebugMode) print("Download document error: $e");
    }
  }

  /// Send document message using multipartImage API
  Future<void> sendDocumentMessage() async {
    if (selectedDocuments.isEmpty) return;

    try {
      // Prepare the body with chat ID, type, and optional text
      Map<String, String> body = {
        'chatId': chatId,
        'type': 'document',
      };

      // Add text caption if provided
      if (messageController.text.isNotEmpty) {
        body['text'] = messageController.text;
        messageController.clear();
      }

      // Prepare files array for multipartImage (using 'doc' as field name)
      List<Map<String, String>> files = [];
      for (var docFile in selectedDocuments) {
        files.add({
          'name': 'doc',
          'image': docFile.path, // API service uses 'image' key for file path
        });
      }

      // Call the multipartImage API
      var response = await ApiService.multipartImage(
        "message",
        body: body,
        files: files,
        method: "POST",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        selectedDocuments.clear();
        update();
      } else {
        Utils.errorSnackBar(
          "Error",
          response.message ?? "Failed to send document",
        );
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to send document: ${e.toString()}");
      if (kDebugMode) print("Send document error: $e");
    }
  }

  /// Main send message logic
  Future<void> addNewMessage() async {
    String text = messageController.text.trim();

    if (text.isEmpty && selectedImages.isEmpty && selectedDocuments.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter a message or select files");
      return;
    }

    isSending = true;
    update();

    try {
      // Send based on what's selected
      if (selectedImages.isNotEmpty) {
        await sendImageMessage();
      } else if (selectedDocuments.isNotEmpty) {
        await sendDocumentMessage();
      } else if (text.isNotEmpty) {
        await sendTextMessage();
      }
    } catch (e) {
      if (kDebugMode) print("Error sending message: $e");
      Utils.errorSnackBar("Error", "Failed to send message");
    } finally {
      isSending = false;
      update();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

// Full Screen Image Viewer
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
