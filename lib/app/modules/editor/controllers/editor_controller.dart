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
  final addressController = TextEditingController();
  final summaryController = TextEditingController();

  final educationList = <Education>[].obs;
  final experienceList = <Experience>[].obs;
  final skillsList = <String>[].obs;
  final projectsList = <Project>[].obs;
  final socialLinksList = <SocialLink>[].obs;
  final certificationsList = <String>[].obs;
  final languagesList = <String>[].obs;

  final currentStep = 0.obs;
  final totalSteps = 9; // Info, Edu, Exp, Skill, Project, Links, Certs, Lang, Finish
  final pageController = PageController();

  final selectedTemplate = TemplateType.modern.obs; // Default to Modern

  final PdfService _pdfService = PdfService();

  @override
  void onInit() {
    super.onInit();
    Get.find<AdService>().loadInterstitial();
  }

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      pageController.animateToPage(currentStep.value, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      saveAndGeneratePDF();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(currentStep.value, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> saveAndGeneratePDF() async {
    // Show Ad
    Get.find<AdService>().showInterstitial();

    final cv = CVModel(
      id: DateTime.now().toString(),
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      summary: summaryController.text,
      educationList: educationList.toList(),
      experienceList: experienceList.toList(),
      skills: skillsList.toList(),
      projects: projectsList.toList(),
      socialLinks: socialLinksList.toList(),
      certifications: certificationsList.toList(),
      languages: languagesList.toList(),
    );
    
    final box = Hive.box<CVModel>('cvs');
    box.add(cv);

    await _pdfService.generatePdf(cv, template: selectedTemplate.value);
  }
}

