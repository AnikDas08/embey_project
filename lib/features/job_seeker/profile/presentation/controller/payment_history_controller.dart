import 'dart:convert';
import 'dart:io';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class PaymentDetailController extends GetxController {
  final isLoading = false.obs;
  final error = ''.obs;
  final subscriptionData = Rxn<Map<String, dynamic>>();
  final isDownloading = false.obs;

  String transactionId = "";
  late Map<String, dynamic> transaction;

  @override
  void onInit() {
    super.onInit();
    // Fetch subscription ID from Get.arguments
    transaction = Get.arguments as Map<String, dynamic>;
    transactionId = transaction['_id'] ?? '';
    if (transactionId != "") {
      fetchSubscriptionDetails();
    }
  }

  Future<void> fetchSubscriptionDetails() async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await ApiService.get("subscription/details/$transactionId");

      if (response.statusCode == 200) {
        final jsonData = response.data;

        if (jsonData['success'] == true) {
          subscriptionData.value = jsonData['data'];
          error.value = '';
        } else {
          error.value = jsonData['message'] ?? 'Failed to fetch subscription details';
        }
      } else {
        error.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Failed to fetch data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> downloadPaymentHistory() async {
    if (subscriptionData.value == null) {
      Get.snackbar('Error', 'No data available to download');
      return;
    }

    isDownloading.value = true;

    try {
      final data = subscriptionData.value!;
      final user = data['user'] ?? {};
      final package = data['package'] ?? {};

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    'Payment History',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 30),

                // Price Section
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '\$${data['price'] ?? '0.00'}',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.orange,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Service Information',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.green100,
                              borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(20),
                              ),
                            ),
                            child: pw.Text(
                              data['status']?.toString().toUpperCase() ?? 'N/A',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        package['name'] ?? 'N/A',
                        style: const pw.TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                // User Information
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'User Information',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 16),
                      _buildPdfInfoRow('Name', user['name'] ?? 'N/A'),
                      pw.Divider(height: 24),
                      _buildPdfInfoRow('Location', user['address'] ?? 'N/A'),
                      pw.Divider(height: 24),
                      _buildPdfInfoRow('E-Mail', user['email'] ?? 'N/A'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                // Payment Details
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Payment Details',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 16),
                      _buildPdfPaymentRow('Service Fee', '\$${data['price'] ?? '0.00'}'),
                      pw.Divider(height: 24),
                      _buildPdfPaymentRow('Transaction ID', data['txId'] ?? 'N/A'),
                      pw.Divider(height: 24),
                      _buildPdfPaymentRow('Start Date', _formatDate(data['startDate'])),
                      pw.Divider(height: 24),
                      _buildPdfPaymentRow('End Date', _formatDate(data['endDate'])),
                      pw.Divider(height: 24),
                      _buildPdfPaymentRow('Tax', '0.0¢'),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),

                // Total
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 12),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.grey300),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Total:  ',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '\$${data['price'] ?? '0.00'}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Save PDF
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'payment_history_${data['txId'] ?? 'document'}.pdf',
      );

      Get.snackbar(
        'Success',
        'Payment history downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey700,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfPaymentRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey700,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void clearError() {
    error.value = '';
  }
}