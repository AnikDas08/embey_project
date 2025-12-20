import 'package:embeyi/core/component/appbar/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class JobWebViewScreen extends StatefulWidget {
  const JobWebViewScreen({super.key});

  @override
  State<JobWebViewScreen> createState() => _JobWebViewScreenState();
}

class _JobWebViewScreenState extends State<JobWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  String? url;
  String? title;

  @override
  void initState() {
    super.initState();

    // Get URL from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    url = args?['url'] as String?;
    title = args?['title'] as String? ?? 'Job Details';

    // Initialize WebView controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            Get.snackbar(
              'Error',
              'Failed to load page: ${error.description}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      );

    if (url != null && url!.isNotEmpty) {
      controller.loadRequest(Uri.parse(url!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: title ?? 'Job Details',
        centerTitle: true,
      ),
      body: url == null || url!.isEmpty
          ? Center(
        child: Text(
          'No URL provided',
          style: TextStyle(fontSize: 16),
        ),
      )
          : Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}