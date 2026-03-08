import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/editor_controller.dart';
import '../../../data/models/cv_model.dart';
import '../../../data/providers/pdf_service.dart';

class EditorView extends GetView<EditorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CV Editor')),
      body: Obx(() => Stepper(
        currentStep: controller.currentStep.value,
        onStepContinue: () {
          if (controller.currentStep.value < 3) {
            controller.currentStep.value++;
          } else {
            controller.saveAndGeneratePDF();
          }
        },
        onStepCancel: () {
          if (controller.currentStep.value > 0) {
            controller.currentStep.value--;
          }
        },
        steps: [
          Step(
            title: Text('Personal'),
            content: Column(
              children: [
                TextField(controller: controller.fullNameController, decoration: InputDecoration(labelText: 'Full Name')),
                TextField(controller: controller.emailController, decoration: InputDecoration(labelText: 'Email')),
                TextField(controller: controller.phoneController, decoration: InputDecoration(labelText: 'Phone')),
                TextField(controller: controller.summaryController, decoration: InputDecoration(labelText: 'Professional Summary'), maxLines: 3),
              ],
            ),
          ),
          Step(
            title: Text('Education & Experience'),
            content: Column(
              children: [
                _buildSectionHeader('Education', () => _showAddEducationDialog(context)),
                Obx(() => Column(
                  children: controller.educationList.map((e) => ListTile(
                    title: Text(e.institution),
                    subtitle: Text('${e.degree} - ${e.year}'),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => controller.educationList.remove(e)),
                  )).toList(),
                )),
                Divider(),
                _buildSectionHeader('Experience', () => _showAddExperienceDialog(context)),
                Obx(() => Column(
                  children: controller.experienceList.map((e) => ListTile(
                    title: Text(e.company),
                    subtitle: Text(e.role),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => controller.experienceList.remove(e)),
                  )).toList(),
                )),
              ],
            ),
          ),
          Step(
            title: Text('Skills'),
            content: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Skills (comma separated)'),
                  onChanged: (val) {
                    controller.skillsList.assignAll(val.split(',').map((e) => e.trim()).toList());
                  },
                ),
              ],
            ),
          ),
          Step(
            title: Text('Template & Finalize'),
            content: Column(
              children: [
                Text('Select a Template:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Obx(() => DropdownButton<TemplateType>(
                  value: controller.selectedTemplate.value,
                  items: TemplateType.values.map((TemplateType type) {
                    return DropdownMenuItem<TemplateType>(
                      value: type,
                      child: Text(type.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (TemplateType? newValue) {
                    if (newValue != null) {
                      controller.selectedTemplate.value = newValue;
                    }
                  },
                )),
                SizedBox(height: 20),
                Text('Ready to generate PDF?'),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: Icon(Icons.add_circle), onPressed: onAdd),
      ],
    );
  }

  void _showAddEducationDialog(BuildContext context) {
    final institutionController = TextEditingController();
    final degreeController = TextEditingController();
    final yearController = TextEditingController();
    
    Get.defaultDialog(
      title: 'Add Education',
      content: Column(
        children: [
          TextField(controller: institutionController, decoration: InputDecoration(labelText: 'Institution')),
          TextField(controller: degreeController, decoration: InputDecoration(labelText: 'Degree')),
          TextField(controller: yearController, decoration: InputDecoration(labelText: 'Year')),
        ],
      ),
      textConfirm: 'Add',
      onConfirm: () {
        controller.educationList.add(Education(
          institution: institutionController.text,
          degree: degreeController.text,
          year: yearController.text,
        ));
        Get.back();
      },
    );
  }

  void _showAddExperienceDialog(BuildContext context) {
    final companyController = TextEditingController();
    final roleController = TextEditingController();
    final durationController = TextEditingController();
    
    Get.defaultDialog(
      title: 'Add Experience',
      content: Column(
        children: [
          TextField(controller: companyController, decoration: InputDecoration(labelText: 'Company')),
          TextField(controller: roleController, decoration: InputDecoration(labelText: 'Role')),
          TextField(controller: durationController, decoration: InputDecoration(labelText: 'Duration')),
        ],
      ),
      textConfirm: 'Add',
      onConfirm: () {
        controller.experienceList.add(Experience(
          company: companyController.text,
          role: roleController.text,
          duration: durationController.text,
        ));
        Get.back();
      },
    );
  }
}
