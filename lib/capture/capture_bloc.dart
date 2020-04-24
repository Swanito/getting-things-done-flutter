import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
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
      yield* _mapDeleteAttachedImageToState(event);
    } else if (event is ClearForm) {
      yield EmptyState();
    } else if (event is DownloadAttachedImage) {
      yield* _mapDownloadAttachedImageToState(event);
    }
  }

  Stream<CaptureState> _mapCaptureToState(Capture event) async* {
    Project newProject;
    String imageRemotePath;

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
      // Create new project if it doesn't exist
      if (newProject == null) {
        newProject = Project(event.project);
        try{
          await _projectRepository.createProject(project: newProject);
        }catch (error) {
          yield ErrorCapturing();
        }
      }
    }

    //Upload taken image to Firebase Storage
    if (event.attachedImage != null) {
      try{
        var uuid = Uuid();
        imageRemotePath = await _elementRepository.uploadFile(event.attachedImage, uuid.v4());
      } catch(error) {
        yield ErrorCapturing();
      }
    }

    try {
      GTDElement element = GTDElement(event.summary,
          description: event.description, project: newProject, imageRemotePath: imageRemotePath);
      _elementRepository.createElement(element);
      yield Captured();
    } catch (error) {
      print(error);
      yield ErrorCapturing();
    }
  }

  Stream<CaptureState> _mapAttachImageToState(AttachImage event) async* {
    yield ImageAttached(attachedImage: event.takenImage, fileName: event.fileName, imageFile: event.imageFile);
  }

  Stream<CaptureState> _mapDeleteAttachedImageToState(DeleteAttachedImage event) async* {
    event.element.imageRemotePath = null;
    _elementRepository.updateElement(event.element);
    yield EmptyState();
  }

  Stream<CaptureState> _mapDownloadAttachedImageToState(DownloadAttachedImage event) async* {
    try {
      String fileUri = await _elementRepository.downloadFileUrl(event.element);
      Image image = Image.network(fileUri);
      yield ImageDownloaded(attachedImage: image, fileName: 'Attached image in ${event.element.summary}');
    } catch(error) {
      yield ErrorDownloadingImage();
    }
  }
}
