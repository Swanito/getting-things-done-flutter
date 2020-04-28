import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';
import 'package:gtd/core/repositories/repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final projectCollection = Firestore.instance.collection('projects');
  String uid;

  @override
  Future<void> createProject({Project project}) async {
    await FirebaseAuth.instance.currentUser().then(
          (value) => project.createdBy = value.uid,
        );
    return projectCollection.add(project.toEntity().toDocument());
  }

  @override
  Future<void> deleteProject(Project project) {
    return projectCollection.document(project.id).delete();
  }

  @override
  Future<QuerySnapshot> getProject(String summary) {
    return projectCollection.where('title', isEqualTo: summary).getDocuments();
  }

  @override
  Future<Stream<List<Project>>> getProjects() async {
    uid = await getCurrentUserId();
    return projectCollection
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.documents
          .map((e) => Project.fromEntity(ProjectEntity.fromSnapshot(e)))
          .toList();
    });
  }

  @override
  Future<void> updateProject({Project project, String id}) {
    return projectCollection
        .document(id)
        .updateData(project.toEntity().toDocument());
  }

  Future<String> getCurrentUserId() async {
    await FirebaseAuth.instance
        .currentUser()
        .then((value) => {uid = value.uid});
    return uid;
  }
}
