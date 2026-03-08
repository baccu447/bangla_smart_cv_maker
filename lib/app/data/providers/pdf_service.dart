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
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(cv.fullName, style: pw.TextStyle(fontSize: 40)),
                pw.Text(cv.email),
                pw.Text(cv.phone),
                pw.Divider(),
                pw.Text('Education', style: pw.TextStyle(fontSize: 20)),
                pw.Text('To be implemented...'), // Placeholder
              ],
            ),
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
