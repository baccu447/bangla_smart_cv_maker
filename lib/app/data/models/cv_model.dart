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
