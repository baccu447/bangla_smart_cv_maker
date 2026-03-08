import 'package:hive/hive.dart';

part 'cv_model.g.dart';

@HiveType(typeId: 0)
class CVModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String address;

  @HiveField(5)
  String summary;

  @HiveField(6)
  List<Education> educationList;

  @HiveField(7)
  List<Experience> experienceList;

  @HiveField(8)
  List<String> skills;

  @HiveField(9)
  List<Project> projects;

  @HiveField(10)
  List<SocialLink> socialLinks;

  @HiveField(11)
  List<String> certifications;

  @HiveField(12)
  List<String> languages;

  CVModel({
    required this.id,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.summary = '',
    this.educationList = const [],
    this.experienceList = const [],
    this.skills = const [],
    this.projects = const [],
    this.socialLinks = const [],
    this.certifications = const [],
    this.languages = const [],
  });
}

@HiveType(typeId: 1)
class Education {
  @HiveField(0)
  String institution;
  
  @HiveField(1)
  String degree;
  
  @HiveField(2)
  String year;

  Education({this.institution = '', this.degree = '', this.year = ''});
}

@HiveType(typeId: 2)
class Experience {
  @HiveField(0)
  String company;
  
  @HiveField(1)
  String role;
  
  @HiveField(2)
  String duration;
  
  @HiveField(3)
  String description;

  Experience({this.company = '', this.role = '', this.duration = '', this.description = ''});
}

@HiveType(typeId: 3)
class Project {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String description;
  
  @HiveField(2)
  String techStack;
  
  @HiveField(3)
  String link;

  Project({this.name = '', this.description = '', this.techStack = '', this.link = ''});
}

@HiveType(typeId: 4)
class SocialLink {
  @HiveField(0)
  String name; // e.g., GitHub, LinkedIn
  
  @HiveField(1)
  String url;

  SocialLink({this.name = '', this.url = ''});
}

