import 'package:bloc_test/bloc_test.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/more/projects/project_state.dart';
import 'package:mockito/mockito.dart';

class MockProjectBloc extends MockBloc<ProjectEvent, ProjectState>
    implements ProjectBloc {}

class MockProjectRepository extends Mock implements ProjectRepository {}

class MockElementRepository extends Mock implements ElementRepository {}

void main() {
  final MockProjectRepository _mockProjectRepository = MockProjectRepository();
  final MockElementRepository _mockElementRepository = MockElementRepository();
  final Project project = Project('Titulo del proyecto');
  blocTest('project bloc initial status is correct',
      build: () async => ProjectBloc(
          elementRepository: _mockElementRepository,
          projectRepository: _mockProjectRepository),
      skip: 0,
      expect: [Loading()]);

  blocTest('ProjectsLoaded yields ProjectsSuccessfullyLoaded',
      build: () async {
        return ProjectBloc(projectRepository: _mockProjectRepository);
      },
      act: (bloc) => bloc.add(ProjectsLoaded([project])),
      expect: [
        ProjectsSuccessfullyLoaded([project])
      ]);

  blocTest('DeleteProject yields ProjectDeleted',
      build: () async {
        return ProjectBloc(projectRepository: _mockProjectRepository);
      },
      act: (bloc) => bloc.add(DeleteProject(project)),
      expect: [ProjectDeleted()]);

    blocTest('EditProject yields ProjectUpdated',
      build: () async {
        return ProjectBloc(projectRepository: _mockProjectRepository);
      },
      act: (bloc) => bloc.add(EditProject(project: project)),
      expect: [ProjectUpdated()]);
}
