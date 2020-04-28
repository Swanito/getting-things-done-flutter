import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';

class Project {
  final String id;
  String title;
  final Timestamp createdAt = Timestamp.now();
  String createdBy;

  Project(this.title, {this.id, this.createdBy});

  @override
  String toString() {
    return 'Project{id: $id, title: $title}';
  }

  ProjectEntity toEntity() {
    return ProjectEntity(id, title, createdAt, createdBy);
  }

  static Project fromEntity(ProjectEntity entity) {
    return Project(entity.title, id: entity.id, createdBy: entity.createdBy);
  }
}
