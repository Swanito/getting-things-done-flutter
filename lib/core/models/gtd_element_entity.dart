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
  final List<String> contexts;

  GTDElementEntity(this.id, this.currentStatus, this.summary, this.description,
      this.project, this.dueDate, this.createdAt, this.contexts, this.asignee);

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
    };
  }

    static GTDElementEntity fromJson(Map<String, Object> json) {
    return GTDElementEntity(
      json["id"] as String,
      json["currentStatus"] as String,
      json["summary"] as String,
      json["description"] as String,
      json["project"] as Project,
      json["dueDate"] as DateTime,
      json["createdAt"] as Timestamp,
      json["contexts"] as List<String>,
      json["asignee"] as String,
    );
  }

  static GTDElementEntity fromSnapshot(DocumentSnapshot snap) {

    Project project = snap.data["project"] != null ? Project.fromEntity(ProjectEntity.fromJson(snap.data["project"])) : null;

    return GTDElementEntity(
      snap.documentID,
      snap.data["currentStatus"],
      snap.data["summary"],
      snap.data["description"],
      project,
      snap.data["dueDate"],
      snap.data["createdAt"],
      snap.data["contexts"],
      snap.data["asignee"]
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
