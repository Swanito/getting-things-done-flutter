import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ElementProcessStatus {
  COMPLETED,
  PROCESSED,
  DELETED,
  WAITINGFOR,
  REFERENCE,
  COLLECTED
}

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final Timestamp createdAt;
  String createdBy;

  ProjectEntity(this.id, this.title, this.createdAt, this.createdBy);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt,
      "createdBy": createdBy
    };
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt,
      "createdBy": createdBy
    };
  }

    static ProjectEntity fromJson(Map<String, Object> json) {
    return ProjectEntity(
      json["id"] as String,
      json["title"] as String,
      json["createdAt"] as Timestamp,
      json["createdBy"] as String
    );
  }

  static ProjectEntity fromSnapshot(DocumentSnapshot snap) {
    return ProjectEntity(
      snap.documentID,
      snap.data["title"],
      snap.data["createdAt"],
      snap.data["createdBy"]
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
