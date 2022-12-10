import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/errors/exceptions.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/programs/data/datasources/programs_remote_datasource.dart';
import 'package:insight/features/programs/data/models/program_model.dart';
import 'package:insight/features/programs/data/repositories/programs_repository_impl.dart';
import 'package:insight/services/http/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockProgramsRemoteDataSource extends Mock
    implements ProgramsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakeProgramModel extends Fake implements ProgramModel {}

void main() {
  late ProgramsRepositoryImpl repository;
  late MockProgramsRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  final List<ProgramModel>? programs = [FakeProgramModel()];
  final serverException = ServerException();
  final unknownException = Exception('unknown');
  final serverFailure = ServerFailure();
  final unknownFailure = UnknownFailure();
  final internetConntectionFailure = InternetConntectionFailure();

  setUp(() {
    mockRemoteDataSource = MockProgramsRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProgramsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);
    reset(mockRemoteDataSource);
  });

  group('online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('successful', () async {
      when(() => mockRemoteDataSource.getPrograms())
          .thenAnswer((_) async => programs);
      final result = await repository.getPrograms();
      expect(result, Right(programs));
      verify((() => mockRemoteDataSource.getPrograms())).called(1);
    });

    test('server failure', () async {
      when(() => mockRemoteDataSource.getPrograms()).thenThrow(serverException);
      final result = await repository.getPrograms();
      expect(result, Left(serverFailure));
      verify((() => mockRemoteDataSource.getPrograms())).called(1);
    });

    test('unknown failure', () async {
      when(() => mockRemoteDataSource.getPrograms())
          .thenThrow(unknownException);
      final result = await repository.getPrograms();
      expect(result, Left(unknownFailure));
      verify((() => mockRemoteDataSource.getPrograms())).called(1);
    });
  });

  group('offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('internet connection failure', () async {
      when(() => mockRemoteDataSource.getPrograms()).thenThrow(serverException);
      final result = await repository.getPrograms();
      expect(result, Left(internetConntectionFailure));
      verifyNever((() => mockRemoteDataSource.getPrograms()));
    });
  });
}
