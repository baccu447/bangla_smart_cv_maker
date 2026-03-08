import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/editor_controller.dart';
import '../../../data/models/cv_model.dart';
import '../../../data/providers/pdf_service.dart';

class EditorView extends GetView<EditorController> {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your CV', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Custom Progress Indicator
          Obx(() => _buildCustomStepper(context)),
          
          Expanded(
            child: Obx(() => PageView(
              controller: controller.pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe, use buttons
              children: [
                _buildPersonalStep(context),
                _buildEducationStep(context),
                _buildExperienceStep(context),
                _buildSkillsStep(context),
                _buildProjectsStep(context),
                _buildLinksStep(context),
                _buildCertificationsStep(context),
                _buildLanguagesStep(context),
                _buildTemplateStep(context),
              ],
            )),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildCustomStepper(BuildContext context) {
    final steps = ["Info", "Edu", "Exp", "Skill", "Project", "Links", "Certs", "Lang", "Finish"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(steps.length, (index) {
          bool isActive = controller.currentStep.value >= index;
          bool isCurrent = controller.currentStep.value == index;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                  ),
                  child: Center(
                    child: isActive 
                      ? Icon(Icons.check, size: 16, color: Colors.white)
                      : Text('${index + 1}', style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ),
                SizedBox(height: 4),
                Text(steps[index], style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Theme.of(context).primaryColor : Colors.grey)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => controller.currentStep.value > 0 
            ? TextButton.icon(
                onPressed: controller.previousStep,
                icon: Icon(Icons.arrow_back),
                label: Text("Back"),
              ) 
            : SizedBox.shrink()),
          
          Obx(() => ElevatedButton.icon(
            onPressed: controller.nextStep,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(controller.currentStep.value == controller.totalSteps - 1 ? Icons.download : Icons.arrow_forward),
            label: Text(controller.currentStep.value == controller.totalSteps - 1 ? "Generate PDF" : "Next"),
          )),
        ],
      ),
    );
  }

  // Step 1: Personal Info
  Widget _buildPersonalStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personal Details", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Let's start with the basics.", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          _buildTextField(controller.fullNameController, "Full Name", Icons.person),
          SizedBox(height: 15),
          _buildTextField(controller.emailController, "Email Address", Icons.email, type: TextInputType.emailAddress),
          SizedBox(height: 15),
          _buildTextField(controller.phoneController, "Phone Number", Icons.phone, type: TextInputType.phone),
          SizedBox(height: 15),
          _buildTextField(controller.addressController, "Location/Address", Icons.location_on),
          SizedBox(height: 15),
          _buildTextField(controller.summaryController, "Professional Summary", Icons.description, maxLines: 4),
        ],
      ),
    );
  }


  // Step 2: Education
  Widget _buildEducationStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "Education", "Add your academic background", () => _showAddEducationDialog(context)),
          SizedBox(height: 20),
          Obx(() => controller.educationList.isEmpty 
            ? _buildEmptyState("No education added yet.")
            : Column(
                children: controller.educationList.map((e) => _buildItemCard(
                  context, 
                  title: e.institution, 
                  subtitle: "${e.degree} • ${e.year}", 
                  onDelete: () => controller.educationList.remove(e)
                )).toList(),
              )
          ),
        ],
      ),
    );
  }

  // Step 3: Experience
  Widget _buildExperienceStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "Experience", "Add your work history", () => _showAddExperienceDialog(context)),
          SizedBox(height: 20),
          Obx(() => controller.experienceList.isEmpty 
            ? _buildEmptyState("No experience added yet.")
            : Column(
                children: controller.experienceList.map((e) => _buildItemCard(
                  context, 
                  title: e.role, 
                  subtitle: "${e.company} • ${e.duration}", 
                  onDelete: () => controller.experienceList.remove(e)
                )).toList(),
              )
          ),
        ],
      ),
    );
  }

  // Step 4: Skills
  Widget _buildSkillsStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Skills", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("List your top technical skills.", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          
          TextField(
            onSubmitted: (val) {
              if (val.isNotEmpty) {
                controller.skillsList.add(val.trim());
              }
            },
            decoration: InputDecoration(
              labelText: "Add skill (e.g. Flutter) and press Enter",
              prefixIcon: Icon(Icons.stars),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 20),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.skillsList.map((s) => Chip(
              label: Text(s),
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              onDeleted: () => controller.skillsList.remove(s),
            )).toList(),
          )),
        ],
      ),
    );
  }

  // Step 5: Projects
  Widget _buildProjectsStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "Projects", "Showcase your best work", () => _showAddProjectDialog(context)),
          SizedBox(height: 20),
          Obx(() => controller.projectsList.isEmpty 
            ? _buildEmptyState("No projects added yet.")
            : Column(
                children: controller.projectsList.map((p) => _buildItemCard(
                  context, 
                  title: p.name, 
                  subtitle: p.techStack, 
                  onDelete: () => controller.projectsList.remove(p)
                )).toList(),
              )
          ),
        ],
      ),
    );
  }

  // Step 6: Social Links
  Widget _buildLinksStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, "Social Links", "GitHub, LinkedIn, Portfolio", () => _showAddLinkDialog(context)),
          SizedBox(height: 20),
          Obx(() => controller.socialLinksList.isEmpty 
            ? _buildEmptyState("No links added yet.")
            : Column(
                children: controller.socialLinksList.map((l) => _buildItemCard(
                  context, 
                  title: l.name, 
                  subtitle: l.url, 
                  onDelete: () => controller.socialLinksList.remove(l)
                )).toList(),
              )
          ),
        ],
      ),
    );
  }

  // Step 7: Certifications
  Widget _buildCertificationsStep(BuildContext context) {
    return _buildTagStep(context, 
      title: "Certifications", 
      subtitle: "Add your professional certifications", 
      hint: "e.g. Google Associate Android Developer", 
      list: controller.certificationsList
    );
  }

  // Step 8: Languages
  Widget _buildLanguagesStep(BuildContext context) {
    return _buildTagStep(context, 
      title: "Languages", 
      subtitle: "Languages you speak/write", 
      hint: "e.g. English (Fluent)", 
      list: controller.languagesList
    );
  }

  // Helper for Certifications and Languages
  Widget _buildTagStep(BuildContext context, {required String title, required String subtitle, required String hint, required RxList<String> list}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(subtitle, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          TextField(
            onSubmitted: (val) {
              if (val.isNotEmpty) {
                list.add(val.trim());
              }
            },
            decoration: InputDecoration(
              labelText: "$hint (Press Enter)",
              prefixIcon: Icon(Icons.add_task),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 20),
          Obx(() => Column(
            children: list.map((item) => Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(item),
                trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => list.remove(item)),
              ),
            )).toList(),
          )),
        ],
      ),
    );
  }

  // Dialogs for Projects and Links
  void _showAddProjectDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final stackCtrl = TextEditingController();
    final linkCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    
    Get.defaultDialog(
      title: 'Add Project',
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(nameCtrl, "Project Name", Icons.folder),
            SizedBox(height: 10),
            _buildTextField(stackCtrl, "Tech Stack (e.g. Flutter, Firebase)", Icons.code),
            SizedBox(height: 10),
            _buildTextField(linkCtrl, "Project Link (Optional)", Icons.link),
            SizedBox(height: 10),
            _buildTextField(descCtrl, "Description", Icons.description, maxLines: 3),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (nameCtrl.text.isNotEmpty) {
            controller.projectsList.add(Project(
              name: nameCtrl.text,
              techStack: stackCtrl.text,
              link: linkCtrl.text,
              description: descCtrl.text,
            ));
            Get.back();
          }
        },
        child: Text("Add"),
      ),
    );
  }

  void _showAddLinkDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    
    Get.defaultDialog(
      title: 'Add Social Link',
      content: Column(
        children: [
          _buildTextField(nameCtrl, "Platform (e.g. GitHub)", Icons.label),
          SizedBox(height: 10),
          _buildTextField(urlCtrl, "URL", Icons.link),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (nameCtrl.text.isNotEmpty) {
            controller.socialLinksList.add(SocialLink(
              name: nameCtrl.text,
              url: urlCtrl.text,
            ));
            Get.back();
          }
        },
        child: Text("Add"),
      ),
    );
  }


  // Step 5: Template & Preview
  Widget _buildTemplateStep(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose Template", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: TemplateType.values.length,
              itemBuilder: (context, index) {
                final type = TemplateType.values[index];
                return Obx(() {
                  bool isSelected = controller.selectedTemplate.value == type;
                  return GestureDetector(
                    onTap: () => controller.selectedTemplate.value = type,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 140,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Colors.white,
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, 
                          width: isSelected ? 2 : 1
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description, size: 50, color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            type.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Theme.of(context).primaryColor : Colors.black87
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isSelected) 
                            Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20)
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          
          SizedBox(height: 30),
          
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(child: Text("Your PDF will be generated with the selected template style.", style: TextStyle(color: Colors.blue.shade800))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: Icon(Icons.add, size: 18),
          label: Text("Add"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            backgroundColor: Colors.black, // Dark accent
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, {required String title, required String subtitle, required VoidCallback onDelete}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.history_edu, color: Theme.of(context).primaryColor),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Container(
      padding: EdgeInsets.all(30),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, size: 40, color: Colors.grey.shade300),
          SizedBox(height: 10),
          Text(text, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Dialogs (Same logic, improved UI)
  void _showAddEducationDialog(BuildContext context) {
    final institutionController = TextEditingController();
    final degreeController = TextEditingController();
    final yearController = TextEditingController();
    
    Get.defaultDialog(
      title: 'Add Education',
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(institutionController, "Institution", Icons.school),
            SizedBox(height: 10),
            _buildTextField(degreeController, "Degree", Icons.workspace_premium),
            SizedBox(height: 10),
            _buildTextField(yearController, "Year (e.g. 2020-2024)", Icons.calendar_today),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (institutionController.text.isNotEmpty) {
            controller.educationList.add(Education(
              institution: institutionController.text,
              degree: degreeController.text,
              year: yearController.text,
            ));
            Get.back();
          }
        },
        child: Text("Add"),
      ),
    );
  }

  void _showAddExperienceDialog(BuildContext context) {
    final companyController = TextEditingController();
    final roleController = TextEditingController();
    final durationController = TextEditingController();
    
    Get.defaultDialog(
      title: 'Add Experience',
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(companyController, "Company", Icons.business),
            SizedBox(height: 10),
            _buildTextField(roleController, "Role", Icons.badge),
            SizedBox(height: 10),
            _buildTextField(durationController, "Duration (e.g. 2 Years)", Icons.timelapse),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (companyController.text.isNotEmpty) {
            controller.experienceList.add(Experience(
              company: companyController.text,
              role: roleController.text,
              duration: durationController.text,
            ));
            Get.back();
          }
        },
        child: Text("Add"),
      ),
    );
  }
}
