import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';

enum ElementProcessStatus {
  COMPLETED,
  PROCESSED,
  DELETED,
  WAITINGFOR,
  REFERENCE,
  COLLECTED
}

class GTDElementEntity extends Equatable {
  final String id;
  final String currentStatus;
  final String summary;
  final String asignee;
  final String description;
  final Project project;
  final DateTime dueDate;
  final Timestamp createdAt;
  final String createdBy;
  final List<String> contexts;

  GTDElementEntity({this.id, this.currentStatus, this.summary, this.description,
      this.project, this.dueDate, this.createdAt, this.contexts, this.asignee, this.createdBy});

  Map<String, Object> toJson() {
    return {
      "id": id,
      "currentStatus": currentStatus,
      "summary": summary,
      "description": description,
      "project": project,
      "dueDate": dueDate,
      "createdAt": createdAt,
      "contexts": contexts,
      "asignee": asignee,
      "createdBy": createdBy
    };
  }

  Map<String, Object> toDocument() {
    return {
      "currentStatus": currentStatus.toString(),
      "summary": summary,
      "description": description,
      "project": project != null ? project.toEntity().toDocument() : null,
      "dueDate": dueDate,
      "createdAt": createdAt,
      "contexts": contexts,
      "asignee": asignee,
      "createdBy": createdBy
    };
  }

    static GTDElementEntity fromJson(Map<String, Object> json) {
    return GTDElementEntity(
      id: json["id"] as String,
      currentStatus: json["currentStatus"] as String,
      summary: json["summary"] as String,
      description: json["description"] as String,
      project: json["project"] as Project,
      dueDate: json["dueDate"] as DateTime,
      createdAt: json["createdAt"] as Timestamp,
      contexts: json["contexts"] as List<String>,
      asignee: json["asignee"] as String,
      createdBy: json["createdBy"] as String,
    );
  }

  static GTDElementEntity fromSnapshot(DocumentSnapshot snap) {

    Project project = snap.data["project"] != null ? Project.fromEntity(ProjectEntity.fromJson(snap.data["project"])) : null;

    return GTDElementEntity(
      id: snap.documentID,
      currentStatus: snap.data["currentStatus"],
      summary: snap.data["summary"],
      description: snap.data["description"],
      project: project,
      dueDate: snap.data["dueDate"],
      createdAt: snap.data["createdAt"],
      contexts: snap.data["contexts"],
      asignee: snap.data["asignee"],
      createdBy: snap.data["createdBy"]
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
