import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insight/core/errors/exceptions.dart';
import 'package:insight/core/errors/failure.dart';
import 'package:insight/features/program_page/data/datasources/program_page_remote_datasource.dart';
import 'package:insight/features/program_page/data/models/program_page_model.dart';
import 'package:insight/features/program_page/data/repositories/program_page_repository_impl.dart';
import 'package:insight/services/http/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockProgramPageRemoteDataSource extends Mock
    implements ProgramPageRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakeProgramPageModel extends Fake implements ProgramPageModel {}

void main() {
  late ProgramPageRepositoryImpl repository;
  late MockProgramPageRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  final ProgramPageModel? programPage = FakeProgramPageModel();
  final serverException = ServerException();
  final unknownException = Exception('unknown');
  final serverFailure = ServerFailure();
  final unknownFailure = UnknownFailure();
  final internetConntectionFailure = InternetConntectionFailure();
  const programPageId = 1;

  setUp(() {
    mockRemoteDataSource = MockProgramPageRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProgramPageRepositoryImpl(
        remoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);
    reset(mockRemoteDataSource);
  });

  group('online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('successful', () async {
      when(() => mockRemoteDataSource.getProgramPage(programPageId))
          .thenAnswer((_) async => programPage);
      final result = await repository.getProgramPage(programPageId);
      expect(result, Right(programPage));
      verify((() => mockRemoteDataSource.getProgramPage(programPageId)))
          .called(1);
    });

    test('server failure', () async {
      when(() => mockRemoteDataSource.getProgramPage(programPageId))
          .thenThrow(serverException);
      final result = await repository.getProgramPage(programPageId);
      expect(result, Left(serverFailure));
      verify((() => mockRemoteDataSource.getProgramPage(programPageId)))
          .called(1);
    });

    test('unknown failure', () async {
      when(() => mockRemoteDataSource.getProgramPage(programPageId))
          .thenThrow(unknownException);
      final result = await repository.getProgramPage(programPageId);
      expect(result, Left(unknownFailure));
      verify((() => mockRemoteDataSource.getProgramPage(programPageId)))
          .called(1);
    });
  });

  group('offline', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('internet connection failure', () async {
      when(() => mockRemoteDataSource.getProgramPage(programPageId))
          .thenThrow(serverException);
      final result = await repository.getProgramPage(programPageId);
      expect(result, Left(internetConntectionFailure));
      verifyNever((() => mockRemoteDataSource.getProgramPage(programPageId)));
    });
  });
}
