import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class RoadmapPdfService {
  static Future<void> exportPdf(
    BuildContext context, {
    required List<RoadmapStepEntity> steps,
    required String title,
  }) async {
    try {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(l10n.exportingPdf),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      final pdfBytes = await generatePdfBytes(steps: steps, title: title);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: '${title.replaceAll(' ', '_')}_roadmap',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export PDF: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<Uint8List> generatePdfBytes({
    required List<RoadmapStepEntity> steps,
    required String title,
  }) async {
    final pdf = pw.Document();

    final primaryColor = PdfColor.fromHex('#0A2A54');
    final secondaryColor = PdfColor.fromHex('#1E4E8C');
    final lightBg = PdfColor.fromHex('#F4F7FB');
    final borderColor = PdfColor.fromHex('#D9E2EF');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 20),
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: primaryColor,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      title.isNotEmpty ? title : 'Department Learning Roadmap',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Step-by-step career path, skills & projects',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: secondaryColor,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text(
                    '${steps.length} Weeks',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 20),
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 9),
            ),
          );
        },
        build: (pw.Context context) {
          return steps.map((step) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 16),
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: lightBg,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: borderColor, width: 1),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Week Header
                  pw.Row(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          color: primaryColor,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          'Week ${step.week}',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Text(
                          step.topic,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (step.goal.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text(
                      step.goal,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ],

                  // Skills
                  if (step.skills.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Skills:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: step.skills.map((skill) {
                        return pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue100,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            skill,
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: primaryColor,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Projects
                  if (step.projects.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Projects:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    ...step.projects.map(
                      (p) => pw.Bullet(
                        text: p,
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                  ],

                  // Deliverables
                  if (step.deliverables.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Deliverables:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    ...step.deliverables.map(
                      (d) => pw.Bullet(
                        text: d,
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                  ],

                  // Resources
                  if (step.resources.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Resources:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    ...step.resources.map(
                      (r) => pw.Bullet(
                        text: r,
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList();
        },
      ),
    );

    return pdf.save();
  }
}
