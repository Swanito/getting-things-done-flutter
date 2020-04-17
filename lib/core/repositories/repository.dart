import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_project.dart';

abstract class Repository {}

abstract class ElementRepository {
  Stream<GTDElement> getElement();
  Future<Stream<List<GTDElement>>> getElements();
  Future<void> createElement(GTDElement element);
  Future<void> updateElement(GTDElement element);
  Future<void> deleteElement(GTDElement element);
}

abstract class ProjectRepository {
  Future<QuerySnapshot> getProject(String summary);
  Stream<List<Project>> getProjects();
  Future<void> createProject({Project project});
  Future<void> updateProject({Project project, String id});
  Future<void> deleteProject(Project project);
}
