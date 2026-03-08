import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cv_model.dart';

class PdfService {
  Future<Uint8List> generatePdf(CVModel cv) async {
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
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(cv.fullName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text(cv.email),
                        pw.Text(cv.phone),
                      ],
                    ),
                    // If image exists, it would be here
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),

              // Summary
              if (cv.summary.isNotEmpty) ...[
                pw.Text('Professional Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.Text(cv.summary),
                pw.SizedBox(height: 15),
              ],

              // Education
              if (cv.educationList.isNotEmpty) ...[
                pw.Text('Education', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                ...cv.educationList.map((e) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(e.institution, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(e.degree),
                        pw.Text(e.year),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                  ],
                )),
                pw.SizedBox(height: 15),
              ],

              // Experience
              if (cv.experienceList.isNotEmpty) ...[
                pw.Text('Experience', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                ...cv.experienceList.map((e) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(e.company, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(e.role),
                        pw.Text(e.duration),
                      ],
                    ),
                    if (e.description.isNotEmpty) pw.Text(e.description, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    pw.SizedBox(height: 10),
                  ],
                )),
                pw.SizedBox(height: 15),
              ],

              // Skills
              if (cv.skills.isNotEmpty) ...[
                pw.Text('Skills', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: cv.skills.map((s) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(s),
                  )).toList(),
                ),
              ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    
    return pdf.save();
  }
}
