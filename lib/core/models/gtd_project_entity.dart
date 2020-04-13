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

  ProjectEntity(this.id, this.title, this.createdAt);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt
    };
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt
    };
  }

    static ProjectEntity fromJson(Map<String, Object> json) {
    return ProjectEntity(
      json["id"] as String,
      json["title"] as String,
      json["createdAt"] as Timestamp
    );
  }

  static ProjectEntity fromSnapshot(DocumentSnapshot snap) {
    return ProjectEntity(
      snap.documentID,
      snap.data["title"],
      snap.data["createdAt"]
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
