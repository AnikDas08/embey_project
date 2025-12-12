import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/model/resume_model.dart';

class PdfDownloadHelper {
  /// Generate and download PDF
  static Future<void> downloadResumePdf(Resume resume) async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header Section
            pw.Center(
              child: _buildPdfHeader(resume),
            ),
            pw.SizedBox(height: 10),

            // Work Authorization Section
            _buildPdfWorkAuth(resume),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 10),

            // Summary Section
            if (resume.personalInfo.summary.isNotEmpty) ...[
              _buildPdfSummary(resume.personalInfo.summary),
              pw.SizedBox(height: 15),
            ],

            // Core Skills Section
            if (resume.coreFeatures.isNotEmpty) ...[
              _buildPdfCoreSkills(resume.coreFeatures),
              pw.SizedBox(height: 15),
            ],

            // Experience Section
            if (resume.workExperiences.isNotEmpty) ...[
              _buildPdfExperience(resume.workExperiences),
              pw.SizedBox(height: 15),
            ],

            // Projects Section
            if (resume.projects.isNotEmpty) ...[
              _buildPdfProjects(resume.projects),
              pw.SizedBox(height: 15),
            ],

            // Education and Certifications
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (resume.educations.isNotEmpty)
                  pw.Expanded(
                    child: _buildPdfEducation(resume.educations),
                  ),
                if (resume.educations.isNotEmpty &&
                    resume.certifications.isNotEmpty)
                  pw.SizedBox(width: 20),
                if (resume.certifications.isNotEmpty)
                  pw.Expanded(
                    child: _buildPdfCertifications(resume.certifications),
                  ),
              ],
            ),
          ],
        ),
      );

      // Save PDF
      await _savePdf(pdf, resume.resumeName);
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  /// Build PDF Header
  static pw.Widget _buildPdfHeader(Resume resume) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          resume.personalInfo.fullName,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Wrap(
          spacing: 15,
          runSpacing: 5,
          alignment: pw.WrapAlignment.center,
          children: [
            if (resume.personalInfo.phone.isNotEmpty)
              _buildContactItem('Phone', resume.personalInfo.phone),
            if (resume.personalInfo.email.isNotEmpty)
              _buildContactItem('Email', resume.personalInfo.email),
            if (resume.personalInfo.socialMediaLink.isNotEmpty)
              _buildContactItem('LinkedIn', resume.personalInfo.socialMediaLink),
            if (resume.personalInfo.githubLink.isNotEmpty)
              _buildContactItem('GitHub', resume.personalInfo.githubLink),
          ],
        ),
      ],
    );
  }

  /// Build Contact Item with styled bullet
  static pw.Widget _buildContactItem(String type, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: 16,
            height: 16,
            decoration: pw.BoxDecoration(
              color: PdfColors.blue700,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Center(
              child: pw.Text(
                _getIconText(type),
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 5),
          pw.Text(
            value.length > 30 ? '${value.substring(0, 30)}...' : value,
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }

  /// Get Icon Text (first letter or symbol)
  static String _getIconText(String type) {
    switch (type.toLowerCase()) {
      case 'phone':
        return 'P';
      case 'email':
        return 'E';
      case 'linkedin':
        return 'L';
      case 'github':
        return 'G';
      default:
        return type.substring(0, 1).toUpperCase();
    }
  }

  /// Build PDF Work Authorization
  static pw.Widget _buildPdfWorkAuth(Resume resume) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          if (resume.personalInfo.workAuthorization.isNotEmpty)
            pw.Expanded(
              child: _buildPdfInfoItem(
                'Work Authorization',
                resume.personalInfo.workAuthorization,
              ),
            ),
          if (resume.personalInfo.clearance.isNotEmpty)
            pw.Expanded(
              child: _buildPdfInfoItem(
                'Clearance',
                resume.personalInfo.clearance,
              ),
            ),
          if (resume.personalInfo.openToWork.isNotEmpty)
            pw.Expanded(
              child: _buildPdfInfoItem(
                'Open To Remote',
                resume.personalInfo.openToWork,
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildPdfInfoItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  /// Build PDF Summary
  static pw.Widget _buildPdfSummary(String summary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfSectionHeader('SUMMARY'),
        pw.SizedBox(height: 5),
        pw.Text(
          summary,
          style: const pw.TextStyle(fontSize: 10),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    );
  }

  /// Build PDF Core Skills
  static pw.Widget _buildPdfCoreSkills(List<CoreFeature> features) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfSectionHeader('CORE SKILLS'),
        pw.SizedBox(height: 5),
        ...features.map((feature) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                feature.title,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                feature.description,
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        )),
      ],
    );
  }

  /// Build PDF Experience
  static pw.Widget _buildPdfExperience(List<WorkExperience> experiences) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfSectionHeader('EXPERIENCE'),
        pw.SizedBox(height: 5),
        ...experiences.map((exp) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      exp.title,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    _formatDateRange(exp.startDate, exp.endDate),
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                ],
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                exp.company,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (exp.location != null && exp.location!.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  exp.location!,
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                ),
              ],
              pw.SizedBox(height: 4),
              pw.Text(
                exp.description,
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        )),
      ],
    );
  }

  /// Build PDF Projects
  static pw.Widget _buildPdfProjects(List<Project> projects) {
    final displayProjects = projects.take(6).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfSectionHeader('SELECTED PROJECTS'),
        pw.SizedBox(height: 5),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: displayProjects.map((project) => pw.Container(
            width: 150,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  project.title,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  project.description,
                  style: const pw.TextStyle(fontSize: 8),
                  maxLines: 4,
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  /// Build PDF Education
  static pw.Widget _buildPdfEducation(List<Education> educations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfSectionHeader('EDUCATION'),
        pw.SizedBox(height: 5),
        ...educations.map((edu) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (edu.degree.isNotEmpty)
                pw.Text(
                  edu.degree,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              if (edu.institution.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  edu.institution,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
              if (edu.passingYear != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  'Year: ${edu.passingYear}',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }

  /// Build PDF Certifications
  static pw.Widget _buildPdfCertifications(List<Certification> certifications) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfSectionHeader('CERTIFICATIONS'),
        pw.SizedBox(height: 5),
        ...certifications.map((cert) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 6,
                    height: 6,
                    margin: const pw.EdgeInsets.only(top: 4, right: 5),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blue700,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      cert.title,
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (cert.description.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 11),
                  child: pw.Text(
                    cert.description,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              ],
            ],
          ),
        )),
      ],
    );
  }

  /// Build Section Header
  static pw.Widget _buildPdfSectionHeader(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 3),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blue700, width: 2),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue700,
        ),
      ),
    );
  }

  /// Format Date Range
  static String _formatDateRange(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) return '';

    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];

      return '${months[start.month - 1]} ${start.year} - ${months[end.month - 1]} ${end.year}';
    } catch (e) {
      return '';
    }
  }

  /// Save PDF to device
  static Future<void> _savePdf(pw.Document pdf, String fileName) async {
    try {
      if (Platform.isAndroid) {
        // Request storage permission for Android
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception('Storage permission denied');
          }
        }

        // For Android 11+ (API 30+)
        if (await Permission.manageExternalStorage.isDenied) {
          final manageStatus = await Permission.manageExternalStorage.request();
          if (!manageStatus.isGranted) {
            // Fallback to app-specific directory
            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/${fileName}_resume.pdf');
            await file.writeAsBytes(await pdf.save());
            await OpenFile.open(file.path);
            return;
          }
        }

        // Save to Downloads folder
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final file = File('${directory.path}/${fileName}_resume.pdf');
        await file.writeAsBytes(await pdf.save());
        await OpenFile.open(file.path);
      } else if (Platform.isIOS) {
        // For iOS, save to app documents directory
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${fileName}_resume.pdf');
        await file.writeAsBytes(await pdf.save());
        await OpenFile.open(file.path);
      } else {
        // For other platforms
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${fileName}_resume.pdf');
        await file.writeAsBytes(await pdf.save());
        await OpenFile.open(file.path);
      }
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }
}