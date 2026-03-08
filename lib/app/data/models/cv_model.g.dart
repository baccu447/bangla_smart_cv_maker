// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CVModelAdapter extends TypeAdapter<CVModel> {
  @override
  final int typeId = 0;

  @override
  CVModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CVModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      phone: fields[3] as String,
      address: fields[4] as String,
      summary: fields[5] as String,
      educationList: (fields[6] as List).cast<Education>(),
      experienceList: (fields[7] as List).cast<Experience>(),
      skills: (fields[8] as List).cast<String>(),
      projects: (fields[9] as List).cast<Project>(),
      socialLinks: (fields[10] as List).cast<SocialLink>(),
      certifications: (fields[11] as List).cast<String>(),
      languages: (fields[12] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CVModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.summary)
      ..writeByte(6)
      ..write(obj.educationList)
      ..writeByte(7)
      ..write(obj.experienceList)
      ..writeByte(8)
      ..write(obj.skills)
      ..writeByte(9)
      ..write(obj.projects)
      ..writeByte(10)
      ..write(obj.socialLinks)
      ..writeByte(11)
      ..write(obj.certifications)
      ..writeByte(12)
      ..write(obj.languages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CVModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 1;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      institution: fields[0] as String,
      degree: fields[1] as String,
      year: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.institution)
      ..writeByte(1)
      ..write(obj.degree)
      ..writeByte(2)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExperienceAdapter extends TypeAdapter<Experience> {
  @override
  final int typeId = 2;

  @override
  Experience read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Experience(
      company: fields[0] as String,
      role: fields[1] as String,
      duration: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Experience obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.company)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 3;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      name: fields[0] as String,
      description: fields[1] as String,
      techStack: fields[2] as String,
      link: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.techStack)
      ..writeByte(3)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SocialLinkAdapter extends TypeAdapter<SocialLink> {
  @override
  final int typeId = 4;

  @override
  SocialLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialLink(
      name: fields[0] as String,
      url: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SocialLink obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
