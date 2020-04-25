import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';
import 'package:gtd/home/procesar/advanced/advanced_process_form.dart';

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
  final String lastStatus;
  final String summary;
  final String asignee;
  final String description;
  final Project project;
  final String dueDate;
  final Timestamp createdAt;
  final String createdBy;
  final List<dynamic> contexts;
  final int repeatInterval;
  final String period;
  final String imageRemotePath;
  final Timestamp completedAt;

  GTDElementEntity({this.id, this.currentStatus, this.lastStatus, this.summary, this.description,
      this.project, this.dueDate, this.createdAt, this.contexts, this.asignee, this.createdBy, this.repeatInterval, this.period, this.imageRemotePath, this.completedAt});

  Map<String, Object> toJson() {
    return {
      "id": id,
      "currentStatus": currentStatus,
      "lastStatus": lastStatus,
      "summary": summary,
      "description": description,
      "project": project,
      "dueDate": dueDate,
      "createdAt": createdAt,
      "contexts": contexts,
      "asignee": asignee,
      "createdBy": createdBy,
      "repeatInterval": repeatInterval,
      "period": period,
      "imageRemotePath": imageRemotePath,
      "completedAt": completedAt
    };
  }

  Map<String, Object> toDocument() {
    return {
      "currentStatus": currentStatus.toString(),
      "lastStatus": lastStatus.toString(),
      "summary": summary,
      "description": description,
      "project": project != null ? project.toEntity().toDocument() : null,
      "dueDate": dueDate,
      "createdAt": createdAt,
      "contexts": contexts,
      "asignee": asignee,
      "createdBy": createdBy,
      "repeatInterval": repeatInterval,
      "period": period,
      "imageRemotePath": imageRemotePath,
      "completedAt": completedAt
    };
  }

    static GTDElementEntity fromJson(Map<String, Object> json) {
    return GTDElementEntity(
      id: json["id"] as String,
      currentStatus: json["currentStatus"] as String,
      lastStatus: json["lastStatus"] as String,
      summary: json["summary"] as String,
      description: json["description"] as String,
      project: json["project"] as Project,
      dueDate: json["dueDate"] as String,
      createdAt: json["createdAt"] as Timestamp,
      contexts: json["contexts"] as List<String>,
      asignee: json["asignee"] as String,
      createdBy: json["createdBy"] as String,
      repeatInterval: json["repeatInterval"] as int,
      period: json["period"] as String,
      imageRemotePath: json["imageRemotePath"] as String,
      completedAt: json["completedAt"] as Timestamp
      );
  }

  static GTDElementEntity fromSnapshot(DocumentSnapshot snap) {

    Project project = snap.data["project"] != null ? Project.fromEntity(ProjectEntity.fromJson(snap.data["project"])) : null;

    return GTDElementEntity(
      id: snap.documentID,
      currentStatus: snap.data["currentStatus"],
      lastStatus: snap.data["lastStatus"],
      summary: snap.data["summary"],
      description: snap.data["description"],
      project: project,
      dueDate: snap.data["dueDate"],
      createdAt: snap.data["createdAt"],
      contexts: snap.data["contexts"],
      asignee: snap.data["asignee"],
      createdBy: snap.data["createdBy"],
      repeatInterval: snap.data["repeatInterval"],
      period: snap.data["period"],
      imageRemotePath: snap.data["imageRemotePath"],
      completedAt: snap.data["completedAt"]
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
