import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cv_model.dart';

enum TemplateType { classic, modern, creative }

class PdfService {
  Future<Uint8List> generatePdf(CVModel cv, {TemplateType template = TemplateType.modern}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: template == TemplateType.modern ? pw.EdgeInsets.zero : const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          switch (template) {
            case TemplateType.classic:
              return _buildClassicTemplate(cv);
            case TemplateType.modern:
              return _buildModernTemplate(cv);
            case TemplateType.creative:
              return _buildCreativeTemplate(cv);
            default:
              return _buildClassicTemplate(cv);
          }
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    
    return pdf.save();
  }

  // 1. Classic Template (Clean, Simple, Black & White)
  pw.Widget _buildClassicTemplate(CVModel cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(cv.fullName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.Text('${cv.email} | ${cv.phone}', style: const pw.TextStyle(color: PdfColors.grey700)),
        pw.Divider(),
        if (cv.summary.isNotEmpty) ...[
          pw.Text('SUMMARY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(cv.summary),
          pw.SizedBox(height: 10),
        ],
        if (cv.educationList.isNotEmpty) ...[
          pw.Text('EDUCATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...cv.educationList.map((e) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(e.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('${e.degree} | ${e.year}'),
            ],
          )),
          pw.SizedBox(height: 10),
        ],
        if (cv.experienceList.isNotEmpty) ...[
          pw.Text('EXPERIENCE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...cv.experienceList.map((e) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(e.company, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('${e.role} | ${e.duration}'),
              if (e.description.isNotEmpty) pw.Text(e.description),
              pw.SizedBox(height: 5),
            ],
          )),
        ]
      ],
    );
  }

  // 2. Modern Template (Sidebar, Blue Accent, Professional)
  pw.Widget _buildModernTemplate(CVModel cv) {
    final accentColor = PdfColor.fromHex('#2c3e50');
    final sidebarColor = PdfColor.fromHex('#ecf0f1');

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Sidebar (30%)
        pw.Expanded(
          flex: 3,
          child: pw.Container(
            color: sidebarColor,
            padding: const pw.EdgeInsets.all(20),
            height: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 80, height: 80,
                  decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, color: accentColor),
                  alignment: pw.Alignment.center,
                  child: pw.Text(cv.fullName.isNotEmpty ? cv.fullName[0] : '', style: pw.TextStyle(color: PdfColors.white, fontSize: 30)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('CONTACT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accentColor)),
                pw.Divider(color: accentColor),
                pw.Text(cv.phone),
                pw.Text(cv.email),
                pw.Text(cv.address),
                pw.SizedBox(height: 20),
                pw.Text('SKILLS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: accentColor)),
                pw.Divider(color: accentColor),
                ...cv.skills.map((s) => pw.Text('• $s')),
              ],
            ),
          ),
        ),
        // Main Content (70%)
        pw.Expanded(
          flex: 7,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(cv.fullName.toUpperCase(), style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: accentColor)),
                pw.SizedBox(height: 5),
                pw.Text('PROFESSIONAL', style: pw.TextStyle(fontSize: 14, letterSpacing: 2, color: PdfColors.grey)),
                pw.SizedBox(height: 20),

                if (cv.summary.isNotEmpty) ...[
                  pw.Text('PROFILE', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: accentColor)),
                  pw.Container(width: 30, height: 2, color: accentColor, margin: const pw.EdgeInsets.only(top: 2, bottom: 5)),
                  pw.Text(cv.summary),
                  pw.SizedBox(height: 15),
                ],

                if (cv.experienceList.isNotEmpty) ...[
                  pw.Text('WORK EXPERIENCE', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: accentColor)),
                  pw.Container(width: 30, height: 2, color: accentColor, margin: const pw.EdgeInsets.only(top: 2, bottom: 5)),
                  ...cv.experienceList.map((e) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(e.role, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(e.company, style: pw.TextStyle(color: PdfColors.grey700, fontStyle: pw.FontStyle.italic)),
                            pw.Text(e.duration, style: const pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        if (e.description.isNotEmpty) pw.Text(e.description, style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  )),
                  pw.SizedBox(height: 15),
                ],

                if (cv.educationList.isNotEmpty) ...[
                  pw.Text('EDUCATION', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: accentColor)),
                  pw.Container(width: 30, height: 2, color: accentColor, margin: const pw.EdgeInsets.only(top: 2, bottom: 5)),
                  ...cv.educationList.map((e) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(e.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(e.degree),
                            pw.Text(e.year, style: const pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 3. Creative Template (Placeholder)
  pw.Widget _buildCreativeTemplate(CVModel cv) {
    return _buildModernTemplate(cv); // Reuse for now, can be customized later
  }
}
