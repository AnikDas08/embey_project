import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  final String initialUrl = Get.arguments; // Receive the Stripe URL

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Check if the URL contains success or cancel indicators
            // Note: Update these strings based on your actual Backend success/cancel URLs
            if (url.contains('success')) {
              Get.back(result: true); // Return true to the controller
            } else if (url.contains('cancel')) {
              Get.back(result: false); // Return false to the controller
              Get.snackbar("Cancelled", "Payment was not completed.");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}