

import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/models/project.dart';
import 'package:meta/meta.dart';

@immutable
class GTDElement {
  final String id;
  final ElementProcessStatus currentStatus;
  final String summary;
  final String description;
  final Project project;
  final DateTime dueDate;
  final DateTime createdAt;
  final List<String> contexts;

  GTDElement(this.id, this.currentStatus, this.summary, this.description, this.project, this.dueDate, this.createdAt, this.contexts);

    @override
  String toString() {
    return 'Element{id: $id, summary: $summary}';
  }

    GTDElementEntity toEntity() {
    return GTDElementEntity(id, currentStatus, summary, description, project, dueDate, createdAt, contexts);
  }

  static GTDElement fromEntity(GTDElementEntity entity) {
    return GTDElement(
      entity.id,
      entity.currentStatus,
      entity.summary,
      entity.description,
      entity.project,
      entity.dueDate,
      entity.createdAt,
      entity.contexts,
    );
  }

}