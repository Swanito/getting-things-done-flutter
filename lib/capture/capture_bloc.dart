import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/capture/capture_validators.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/models/gtd_project_entity.dart';
import 'package:gtd/core/repositories/remote/project_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  final UserRepository _userRepository;
  final ElementRepository _elementRepository;
  final ProjectRepository _projectRepository = ProjectRepositoryImpl();

  CaptureBloc({@required userRepository, @required elementRepository})
      : assert(userRepository != null),
        assert(elementRepository != null),
        _elementRepository = elementRepository,
        _userRepository = userRepository;

  @override
  CaptureState get initialState => EmptyState();

  @override
  Stream<CaptureState> mapEventToState(CaptureEvent event) async* {
    if (event is Capture) {
      yield* _mapCaptureToState(event);
    } else if(event is AttachImage) {
      yield* _mapAttachImageToState(event);
    } else if(event is DeleteAttachedImage) {
      yield* _mapDeleteAttachedImageToState();
    }
  }

  Stream<CaptureState> _mapCaptureToState(Capture event) async* {
          Project newProject;

    if (event.project != "") {
      Future<QuerySnapshot> projectsSnapshot =
          _projectRepository.getProject(event.project);

      newProject = await projectsSnapshot.then((value) {
        if (value.documents.isNotEmpty) {
          Map<String, Object> projectFromJson = {
            "id": value.documents[0].documentID,
            "title": value.documents[0].data["title"],
            "createdAt": value.documents[0].data["createdAt"]
          };

          return Project.fromEntity(ProjectEntity.fromJson(projectFromJson));
        }
      });

      if (newProject == null) {
        newProject = Project(event.project);
        await _projectRepository.createProject(project: newProject);
      }
    }

    try {
      GTDElement element = GTDElement(event.summary,
          description: event.description, project: newProject);
      _elementRepository.createElement(element);
      yield Captured();
    } catch (error) {
      print(error);
      yield ErrorCapturing();
    }
  }

  Stream<CaptureState> _mapAttachImageToState(AttachImage event) async* {
    print('aqui viene lo dificil');
    print(state);
    yield ImageAttached(attachedImage: event.takenImage, fileName: event.fileName);
    print(state);
  }

  Stream<CaptureState> _mapDeleteAttachedImageToState() async* {
    yield EmptyState();
  }
}
