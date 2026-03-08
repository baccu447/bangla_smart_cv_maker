import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/cv_model.dart';
import '../../../data/providers/pdf_service.dart';
import '../../../data/services/ad_service.dart';

class EditorController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final summaryController = TextEditingController();

  final educationList = <Education>[].obs;
  final experienceList = <Experience>[].obs;
  final skillsList = <String>[].obs;

  final currentStep = 0.obs;
  final selectedTemplate = TemplateType.modern.obs; // Default to Modern

  final PdfService _pdfService = PdfService();

  @override
  void onInit() {
    super.onInit();
    Get.find<AdService>().loadInterstitial();
  }

  void addEducation() {
    educationList.add(Education(
      institution: 'University/School', 
      degree: 'Degree', 
      year: 'Year'
    ));
  }

  void addExperience() {
    experienceList.add(Experience(
      company: 'Company',
      role: 'Role',
      duration: 'Duration',
      description: 'Description'
    ));
  }

  void addSkill() {
    skillsList.add('New Skill');
  }

  Future<void> saveAndGeneratePDF() async {
    // Show Ad
    Get.find<AdService>().showInterstitial();

    final cv = CVModel(
      id: DateTime.now().toString(),
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      summary: summaryController.text,
      educationList: educationList.toList(),
      experienceList: experienceList.toList(),
      skills: skillsList.toList(),
    );
    
    // In a real app, save to Hive here.
    final box = Hive.box<CVModel>('cvs');
    box.add(cv);

    await _pdfService.generatePdf(cv, template: selectedTemplate.value);
  }
}
