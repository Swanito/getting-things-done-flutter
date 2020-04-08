import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gtd/core/models/project.dart';

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
  final String description;
  final Project project;
  final DateTime dueDate;
  final DateTime createdAt;
  final List<String> contexts;

  GTDElementEntity(this.id, this.currentStatus, this.summary, this.description,
      this.project, this.dueDate, this.createdAt, this.contexts);

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
    };
  }

  Map<String, Object> toDocument() {
    return {
      "currentStatus": currentStatus.toString(),
      "summary": summary,
      "description": description,
      "project": project,
      "dueDate": dueDate,
      "createdAt": createdAt,
      "contexts": contexts,
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
      json["createdAt"] as DateTime,
      json["contexts"] as List<String>,
    );
  }

  static GTDElementEntity fromSnapshot(DocumentSnapshot snap) {
    return GTDElementEntity(
      snap.documentID,
      snap.data["currentStatus"],
      snap.data["summary"],
      snap.data["description"],
      snap.data["project"],
      snap.data["dueDate"],
      snap.data["createdAt"],
      snap.data["contexts"],
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
