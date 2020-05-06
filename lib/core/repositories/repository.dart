import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_project.dart';

import 'local/local_state_bloc.dart';

abstract class ElementRepository {
  Future<Stream<List<GTDElement>>> getElements();
  Future<void> createElement(GTDElement element);
  Future<void> updateElement(GTDElement element);
  Future<void> deleteElement(GTDElement element);
  Future uploadFile(File file, String uuid);
  Future downloadFileUrl(GTDElement element);
  Future<String> getCurrentUserId();
}

abstract class ProjectRepository {
  Future<QuerySnapshot> getProject(String summary);
  Future<Stream<List<Project>>> getProjects();
  Future<void> createProject({Project project});
  Future<void> updateProject({Project project, String id});
  Future<void> deleteProject(Project project);
}

abstract class Repository {
  Future<void> setGTDLevel(GTDLevel level);
  Future<String> getGTDLevel();
  Future<void> setNotificationsAllowed(bool areAllowed);
  Future<bool> getNotificationsAllowed();
  Future<void> completeOnboard();
  Future<bool> isOnboardingCompleted();
  Future<void> logout();
}

abstract class UserAbstractRepository {
  Future<void> signInWithCredentials(String email, String password);
  Future<void> signUp({String email, String password});
  Future<void> sendEmailVerificationLink(FirebaseUser user);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String> getUser();
  Future<FirebaseUser> getUserProfile();
  Future<bool> isEmailVerified();
  Future<void> resetPassword(String email);
}
