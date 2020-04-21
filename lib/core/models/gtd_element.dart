import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:meta/meta.dart';

@immutable
class GTDElement {
  final String id;
  String currentStatus;
  String lastStatus;
  String summary;
  String description;
  String asignee;
  String createdBy;
  Project project;
  String dueDate;
  final Timestamp createdAt = Timestamp.now();
  List<dynamic> contexts;

  GTDElement(this.summary, 
      {this.id,
      this.asignee = null,
      this.currentStatus = 'COLLECTED',
      this.lastStatus = null,
      this.description = '',
      this.createdBy,
      this.project = null,
      this.dueDate = null,
      this.contexts = null});

  @override
  String toString() {
    return 'Element{id: $id, summary: $summary, project: $project}';
  }

  GTDElementEntity toEntity() {
    return GTDElementEntity(
      id: id,
      summary: summary,
      description: description,
      asignee: asignee,
      contexts: contexts,
      createdAt: createdAt,
      createdBy: createdBy,
      currentStatus: currentStatus,
      lastStatus: lastStatus,
      dueDate: dueDate,
      project: project
    );
  }

  static GTDElement fromEntity(GTDElementEntity entity) {
    return GTDElement(entity.summary,
        description: entity.description,
        contexts: entity.contexts,
        project: entity.project,
        id: entity.id,
        dueDate: entity.dueDate,
        asignee: entity.asignee,
        currentStatus: entity.currentStatus,
        lastStatus: entity.lastStatus,
        createdBy: entity.createdBy);
  }
}
