import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/repositories/repository.dart';

class ElementRepositoryImpl implements ElementRepository {
  final elementCollection = Firestore.instance.collection('elements');
  String uid;

  /// Stores a [GTDElement] in the Firestore instance for the current user.
  @override
  Future<void> createElement(GTDElement element) async {
    await FirebaseAuth.instance.currentUser().then(
          (value) => element.createdBy = value.uid,
        );
    return elementCollection.add(element.toEntity().toDocument());
  }

  /// Deletes a [GTDElement] from the Firestore instance for the current user.
  @override
  Future<void> deleteElement(GTDElement element) {
    return elementCollection.document(element.id).delete();
  }

  /// Gets all the [GTDElement]s from the Firestore instance for the current user.
  @override
  Future<Stream<List<GTDElement>>> getElements() async {
    uid = await getCurrentUserId();
    return elementCollection
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.documents
          .map((e) => GTDElement.fromEntity(GTDElementEntity.fromSnapshot(e)))
          .toList();
    });
  }

  /// Updates the given [GTDElement].
  @override
  Future<void> updateElement(GTDElement element) {
    return elementCollection
        .document(element.id)
        .updateData(element.toEntity().toDocument());
  }

  /// Uploads a `File` to Firebase Storage. The `File` is stored in an unique path using an auto-generated `uuid` and the `uid` from the user.
  @override
  Future uploadFile(File file, String uuid) async {
    uid = await getCurrentUserId();
    String remotePath = 'elements/$uid/$uuid';
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(remotePath);
    storageReference.putFile(file);
    return remotePath;
  }

  /// Downloads the `File` associated to the given [GTDElement]. 
  /// If no `file` is associated, prints an error.
  @override
  Future downloadFileUrl(GTDElement element) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(element.imageRemotePath);
      String url = await storageReference.getDownloadURL();
      return url;
    } catch (error) {
      print(error);
    }
  }

  /// Returns a `Future<String>` with the current users uid.
  @override
  Future<String> getCurrentUserId() async {
    await FirebaseAuth.instance
        .currentUser()
        .then((value) => {uid = value.uid});
    return uid;
  }
}
