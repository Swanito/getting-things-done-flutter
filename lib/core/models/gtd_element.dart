import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/models/gtd_project.dart';

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
  int repeatInterval;
  String period;
  String imageRemotePath;
  Timestamp completedAt;

  GTDElement(this.summary, 
      {this.id,
      this.asignee,
      this.currentStatus = 'COLLECTED',
      this.lastStatus,
      this.description = '',
      this.createdBy,
      this.project,
      this.dueDate,
      this.repeatInterval,
      this.contexts,
      this.period,
      this.imageRemotePath,
      this.completedAt});

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
      project: project,
      repeatInterval: repeatInterval,
      period: period,
      imageRemotePath: imageRemotePath,
      completedAt: completedAt
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
        createdBy: entity.createdBy,
        repeatInterval: entity.repeatInterval,
        period: entity.period,
        imageRemotePath: entity.imageRemotePath,
        completedAt: entity.completedAt);
  }
}
