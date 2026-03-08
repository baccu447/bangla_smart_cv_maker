import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cv_model.dart';

enum TemplateType { classic, modern, creative, professionalGray, minimalModern, technicalCol }

class PdfService {
  Future<Uint8List> generatePdf(CVModel cv, {TemplateType template = TemplateType.modern}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: (template == TemplateType.modern || template == TemplateType.minimalModern)
            ? pw.EdgeInsets.zero 
            : const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          switch (template) {
            case TemplateType.classic:
              return _buildClassicTemplate(cv);
            case TemplateType.modern:
              return _buildModernTemplate(cv);
            case TemplateType.creative:
              return _buildCreativeTemplate(cv);
            case TemplateType.professionalGray:
              return _buildProfessionalGrayTemplate(cv);
            case TemplateType.minimalModern:
              return _buildMinimalModernTemplate(cv);
            case TemplateType.technicalCol:
              return _buildTechnicalColTemplate(cv);
            // Default case removed as all cases are covered, preventing unreachable code warning.
          }
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    
    return pdf.save();
  }

  // 1. Classic Template
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

  // 2. Modern Template
  pw.Widget _buildModernTemplate(CVModel cv) {
    final accentColor = PdfColor.fromHex('#2c3e50');
    final sidebarColor = PdfColor.fromHex('#ecf0f1');

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
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

  // 3. Creative Template
  pw.Widget _buildCreativeTemplate(CVModel cv) {
    return _buildModernTemplate(cv);
  }

  // 4. Professional Gray Template
  pw.Widget _buildProfessionalGrayTemplate(CVModel cv) {
    final headerBoxColor = PdfColor.fromHex('#e6e8eb'); // Light gray box

    pw.Widget sectionHeader(String title) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              color: headerBoxColor,
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, letterSpacing: 1),
              ),
            ),
            pw.Expanded(
              child: pw.Container(
                height: 1,
                color: PdfColors.black,
              ),
            )
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Name & Role
        pw.Text(cv.fullName.toUpperCase(), style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('Software Engineer', style: pw.TextStyle(fontSize: 14)), // Placeholder role if not in model

        pw.SizedBox(height: 15),

        // Contact Bar
        pw.Container(
          color: headerBoxColor,
          padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(cv.phone),
              pw.Text(cv.address), // Placeholder
              pw.Text(cv.email),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // About Me
        if (cv.summary.isNotEmpty) ...[
          sectionHeader('About Me'),
          pw.Text(cv.summary),
          pw.SizedBox(height: 15),
        ],

        // Education
        if (cv.educationList.isNotEmpty) ...[
          sectionHeader('Education'),
          ...cv.educationList.map((e) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(e.institution.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(e.degree, style: const pw.TextStyle(color: PdfColors.grey800)),
                  ],
                ),
                pw.Text(e.year),
              ],
            ),
          )),
          pw.SizedBox(height: 15),
        ],

        // Skills
        if (cv.skills.isNotEmpty) ...[
          sectionHeader('Skill'),
          pw.Wrap(
            spacing: 20,
            runSpacing: 5,
            children: cv.skills.map((s) => pw.Bullet(text: s)).toList(),
          ),
          pw.SizedBox(height: 15),
        ],

        // Work Experience
        if (cv.experienceList.isNotEmpty) ...[
          sectionHeader('Work Experience'),
          ...cv.experienceList.map((e) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${e.company} - ${e.role}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(e.duration, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Text(e.description),
              ],
            ),
          )),
        ],
      ],
    );
  }

  // 5. Minimal Modern Template
  pw.Widget _buildMinimalModernTemplate(CVModel cv) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(40),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(cv.fullName.toUpperCase(), style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, letterSpacing: 1.5)),
                pw.SizedBox(height: 5),
                pw.Text('Professional Accountant', style: const pw.TextStyle(fontSize: 16)), // Placeholder Role
              ],
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Text('+ ${cv.phone}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Text(cv.email, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Text(cv.address, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 0.5, color: PdfColors.grey),
          pw.SizedBox(height: 20),
          if (cv.summary.isNotEmpty) ...[
            pw.Text('ABOUT ME', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 1)),
            pw.SizedBox(height: 10),
            pw.Text(cv.summary, style: const pw.TextStyle(lineSpacing: 2, fontSize: 10, color: PdfColors.grey800)),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 0.5, color: PdfColors.grey),
            pw.SizedBox(height: 20),
          ],
          if (cv.educationList.isNotEmpty) ...[
            pw.Text('EDUCATION', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 1)),
            pw.SizedBox(height: 15),
            ...cv.educationList.map((e) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text(e.institution, style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 11)),
                      pw.Text(' | ${e.year}', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 11)),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(e.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
                ],
              ),
            )),
            pw.Divider(thickness: 0.5, color: PdfColors.grey),
            pw.SizedBox(height: 20),
          ],
          if (cv.experienceList.isNotEmpty) ...[
            pw.Text('WORK EXPERIENCE', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 1)),
            pw.SizedBox(height: 15),
            ...cv.experienceList.map((e) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Text(e.company, style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 11)),
                      pw.Text(' | ${e.duration}', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 11)),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(e.role, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Text(e.description.isEmpty ? 'Responsibility description goes here.' : e.description, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
                ],
              ),
            )),
            pw.Divider(thickness: 0.5, color: PdfColors.grey),
            pw.SizedBox(height: 20),
          ],
          if (cv.skills.isNotEmpty) ...[
            pw.Text('SKILLS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 1)),
            pw.SizedBox(height: 10),
            pw.Wrap(
              spacing: 40,
              runSpacing: 10,
              children: cv.skills.map((s) => pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    width: 3, height: 3, 
                    decoration: const pw.BoxDecoration(color: PdfColors.black, shape: pw.BoxShape.circle),
                    margin: const pw.EdgeInsets.only(right: 5),
                  ),
                  pw.Text(s, style: const pw.TextStyle(fontSize: 11)),
                ],
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // 6. Technical Column Template
  pw.Widget _buildTechnicalColTemplate(CVModel cv) {
    pw.Widget sectionHeader(String text) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(text.toUpperCase(), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Divider(thickness: 2, color: PdfColors.black),
          pw.SizedBox(height: 5),
        ],
      );
    }

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left Column (65%)
        pw.Expanded(
          flex: 65,
          child: pw.Container(
            padding: const pw.EdgeInsets.only(right: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(cv.fullName.toUpperCase(), style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                pw.Text('iOS Swift Mobile App Developer', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#444444'))),
                
                pw.SizedBox(height: 10),
                
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(cv.phone, style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(cv.email, style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(cv.address, style: const pw.TextStyle(fontSize: 9)),
                  ]
                ),

                pw.SizedBox(height: 20),

                sectionHeader('Summary'),
                pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 15),

                sectionHeader('Experience'),
                ...cv.experienceList.map((e) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(e.role, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text(e.company, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#2980b9'))),
                      pw.Text(e.duration, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.SizedBox(height: 3),
                      pw.Text(e.description, style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                )),

                pw.SizedBox(height: 15),
                sectionHeader('Education'),
                 ...cv.educationList.map((e) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(e.institution, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      pw.Text(e.degree, style: const pw.TextStyle(fontSize: 10)),
                      pw.Text(e.year, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        
        // Right Column (35%)
        pw.Expanded(
          flex: 35,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 80), // Offset for alignment
              sectionHeader('Projects'),
              // Placeholder projects logic
              pw.Text('Open Source Fitness Tracker', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text('Contributed to developing new features for a community-driven fitness tracking app.', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),

              sectionHeader('Achievements'),
              pw.Text('App Store Top Chart', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text('Led development of educational app that reached top 10.', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),

              sectionHeader('Skills'),
              pw.Wrap(
                runSpacing: 5,
                children: cv.skills.map((s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  width: double.infinity,
                  child: pw.Column(
                     crossAxisAlignment: pw.CrossAxisAlignment.start,
                     children: [
                        pw.Text(s, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                        pw.Container(height: 1, width: double.infinity, color: PdfColors.grey300)
                     ]
                  )
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
