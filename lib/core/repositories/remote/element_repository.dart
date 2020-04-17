import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/repositories/repository.dart';

class ElementRepositoryImpl implements ElementRepository {
    final elementCollection = Firestore.instance.collection('elements');
    String uid;

  @override
  Future<void> createElement(GTDElement element) async {
    await FirebaseAuth.instance.currentUser().then((value) => 
      element.createdBy = value.uid,
    );
    return elementCollection.add(element.toEntity().toDocument());
  }

  @override
  Future<void> deleteElement(GTDElement element) {
    return elementCollection.document(element.id).delete();
  }

  @override
  Stream<GTDElement> getElement() {

  }

  @override
  Future<Stream<List<GTDElement>>> getElements() async {

    uid = await getCurrentUserId();
    print('Current user uid: ${uid}');
    return elementCollection.where('createdBy', isEqualTo: uid).snapshots().map((event) {
        return event.documents
          .map((e) => GTDElement.fromEntity(GTDElementEntity.fromSnapshot(e)))
          .toList();
    });
  }

  @override
  Future<void> updateElement(GTDElement element) {
        return elementCollection
        .document(element.id)
        .updateData(element.toEntity().toDocument());
  }
  
  Future<String> getCurrentUserId() async {
    await FirebaseAuth.instance.currentUser().then((value) => {
      uid = value.uid
    });
    return uid;
  }

}