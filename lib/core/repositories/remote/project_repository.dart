
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';
import 'package:gtd/core/repositories/repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final projectCollection = Firestore.instance.collection('projects');

  @override
  Future<void> createProject({Project project}) {
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
  Stream<List<Project>> getProjects() {
    return projectCollection.snapshots().map((event) {
        return event.documents
          .map((e) => Project.fromEntity(ProjectEntity.fromSnapshot(e)))
          .toList();
    });  }

  @override
  Future<void> updateProject({Project project, String id}) {
    return projectCollection.document(id).updateData(project.toEntity().toDocument());
  }

}