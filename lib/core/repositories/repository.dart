import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/project.dart';

abstract class Repository {}

abstract class ElementRepository {
  Stream<GTDElement> getElement();
  Stream<List<GTDElement>> getElements();
  Future<void> createElement(GTDElement element);
  Future<void> updateElement(GTDElement element);
  Future<void> deleteElement(GTDElement element);
}

abstract class ProjectRepository {
  // Stream<Project> getProject();
  // Stream<List<Project>> getProjects();
  // Future<Project> createProject();
  // Future<Project> updateProject();
  // Future<Project> deleteProject();
}
