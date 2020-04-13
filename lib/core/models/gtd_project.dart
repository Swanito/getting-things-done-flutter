import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Project {
  final String id;
  final String title;
  final Timestamp createdAt;

  Project(this.title, {this.id, this.createdAt});

  @override
  String toString() {
    return 'Project{id: $id, title: $title}';
  }

  ProjectEntity toEntity() {
    return ProjectEntity(id, title, createdAt);
  }

  static Project fromEntity(ProjectEntity entity) {
    return Project(entity.title, id: entity.id);
  }
}
