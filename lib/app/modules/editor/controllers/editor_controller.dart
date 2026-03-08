import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cv_model.dart';
import '../../../data/providers/pdf_service.dart';

class EditorController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final PdfService _pdfService = PdfService();

  Future<void> saveAndGeneratePDF() async {
    final cv = CVModel(
      id: DateTime.now().toString(),
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
    );
    
    // In a real app, save to Hive here.
    
    await _pdfService.generatePdf(cv);
  }
}
