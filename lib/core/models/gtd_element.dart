import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/models/project.dart';
import 'package:meta/meta.dart';

@immutable
class GTDElement {
  final String id;
  String currentStatus;
  final String summary;
  final String description;
  final Project project;
  final DateTime dueDate;
  final DateTime createdAt;
  final List<String> contexts;

  GTDElement(this.summary,
      {this.id,
      this.currentStatus = 'COLLECTED',
      this.description = '',
      this.project = null,
      this.dueDate = null,
      this.createdAt = null,
      this.contexts = null});

  @override
  String toString() {
    return 'Element{id: $id, summary: $summary}';
  }

  GTDElementEntity toEntity() {
    return GTDElementEntity(id, currentStatus, summary, description, project,
        dueDate, createdAt, contexts);
  }

  static GTDElement fromEntity(GTDElementEntity entity) {
    return GTDElement(entity.summary,
        description: entity.description,
        contexts: entity.contexts,
        project: entity.project,
        id: entity.id,
        dueDate: entity.dueDate,
        currentStatus: entity.currentStatus,
        createdAt: entity.createdAt);
  }
}
