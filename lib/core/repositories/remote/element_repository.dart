import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ElementRepositoryImpl implements ElementRepository {
    final elementCollection = Firestore.instance.collection('elements');

  @override
  Future<void> createElement(GTDElement element) {
    return elementCollection.add(element.toEntity().toDocument());
  }

  @override
  Future<GTDElement> deleteElement(GTDElement element) {
    return elementCollection.document(element.id).delete();
  }

  @override
  Stream<GTDElement> getElement() {
    // TODO: implement getElement
  }

  @override
  Stream<List<GTDElement>> getElements() {
    return elementCollection.snapshots().map((event) {
        return event.documents
          .map((e) => GTDElement.fromEntity(GTDElementEntity.fromSnapshot(e)))
          .toList();
    });
  }

  @override
  Future<GTDElement> updateElement(GTDElement element) {
        return elementCollection
        .document(element.id)
        .updateData(element.toEntity().toDocument());
  }
  
}