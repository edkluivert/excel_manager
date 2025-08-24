import 'package:excel_manager/core/result/result.dart';
import 'package:excel_manager/data/data_sources/local/project_local_ds.dart';
import 'package:excel_manager/data/data_sources/remote/mock_api.dart';
import 'package:excel_manager/data/models/project_model.dart';
import 'package:excel_manager/data/repositories/project_repo_impl.dart';
import 'package:excel_manager/domain/entities/project.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDS extends Mock implements ProjectLocalDataSource {}
class MockRemoteAPI extends Mock implements MockApi {}

void main() {
  late ProjectRepositoryImpl repository;
  late MockLocalDS mockLocal;
  late MockRemoteAPI mockRemote;

  setUp(() {
    mockLocal = MockLocalDS();
    mockRemote = MockRemoteAPI();
    repository = ProjectRepositoryImpl(local: mockLocal, remote: mockRemote);
  });

  final tProjectModel = ProjectModel(
      id: '1',
      name: 'Test Project',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());

  group('create', () {
    test('return Success when local and remote create succeed', () async {
      // arrange
      when(() => mockLocal.create('Test Project'))
          .thenAnswer((_) async => tProjectModel);
      when(() => mockRemote.createProject('Test Project'))
          .thenAnswer((_) async => tProjectModel);

      // act
      final result = await repository.create('Test Project');

      // assert
      expect(result, isA<Success<Project>>());
      expect((result as Success).data.name, 'Test Project');
      verify(() => mockLocal.create('Test Project')).called(1);
      verify(() => mockRemote.createProject('Test Project')).called(1);
    });

    test('return Failure when local.create throws', () async {
      when(() => mockLocal.create('Test Project'))
          .thenThrow(Exception('Local error'));

      final result = await repository.create('Test Project');

      expect(result, isA<Failure>());
      verifyNever(() => mockRemote.createProject(any()));
    });

    test('return Failure when remote.createProject throws', () async {
      when(() => mockLocal.create('Test Project'))
          .thenAnswer((_) async => tProjectModel);
      when(() => mockRemote.createProject('Test Project'))
          .thenThrow(Exception('Remote error'));

      final result = await repository.create('Test Project');

      expect(result, isA<Failure>());
      verify(() => mockLocal.create('Test Project')).called(1);
      verify(() => mockRemote.createProject('Test Project')).called(1);
    });
  });

  group('delete', () {
    test('return Success when delete succeeds', () async {
      when(() => mockLocal.delete('1')).thenAnswer((_) async {});
      when(() => mockRemote.deleteProject('1')).thenAnswer((_) async {});

      final result = await repository.delete('1');

      expect(result, isA<Success<void>>());
      verify(() => mockLocal.delete('1')).called(1);
      verify(() => mockRemote.deleteProject('1')).called(1);
    });

    test('return Failure when delete fails', () async {
      when(() => mockLocal.delete('1')).thenThrow(Exception('Delete error'));

      final result = await repository.delete('1');

      expect(result, isA<Failure>());
      verifyNever(() => mockRemote.deleteProject(any()));
    });
  });

  group('getAll', () {
    test('return list of projects on success', () async {
      when(() => mockLocal.getAll()).thenAnswer((_) async => [tProjectModel]);

      final result = await repository.getAll();

      expect(result, isA<Success<List<Project>>>());
      expect((result as Success).data.length, 1);
      expect(result.data.first.name, 'Test Project');
      verify(() => mockLocal.getAll()).called(1);
    });

    test('return Failure when local.getAll throws', () async {
      when(() => mockLocal.getAll()).thenThrow(Exception('Error fetching'));

      final result = await repository.getAll();

      expect(result, isA<Failure>());
    });
  });
}
