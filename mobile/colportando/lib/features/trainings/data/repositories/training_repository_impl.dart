import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/trainings/data/sources/training_remote_data_source.dart';
import 'package:colportando/features/trainings/domain/entities/training_progress.dart';
import 'package:colportando/features/trainings/domain/repositories/training_repository.dart';

// Implementación concreta del repositorio de capacitación (Training).
class TrainingRepositoryImpl implements ITrainingRepository {
  final ITrainingRemoteDataSource remoteDataSource;
  const TrainingRepositoryImpl({required this.remoteDataSource});

  String get _token => SecureStorage.accessToken ?? '';

  @override
  Future<Result<Map<String, dynamic>>> createProgram({
    required String clubId,
    required String code,
    required String name,
    required String versionLabel,
    String? startsOn,
    String? endsOn,
  }) => remoteDataSource.createProgram(
    accessToken: _token,
    clubId: clubId,
    code: code,
    name: name,
    versionLabel: versionLabel,
    startsOn: startsOn,
    endsOn: endsOn,
  );

  @override
  Future<Result<Map<String, dynamic>>> createSession({
    required String versionId,
    required String title,
    required String startsAt,
    required String endsAt,
  }) => remoteDataSource.createSession(
    accessToken: _token,
    versionId: versionId,
    title: title,
    startsAt: startsAt,
    endsAt: endsAt,
  );

  @override
  Future<Result<Map<String, dynamic>>> createEnrollment({
    required String versionId,
    required String membershipId,
  }) => remoteDataSource.createEnrollment(
    accessToken: _token,
    versionId: versionId,
    membershipId: membershipId,
  );

  @override
  Future<Result<Map<String, dynamic>>> changeSessionStatus({
    required String sessionId,
    required String status,
  }) => remoteDataSource.changeSessionStatus(
    accessToken: _token,
    sessionId: sessionId,
    status: status,
  );

  @override
  Future<Result<Map<String, dynamic>>> recordAttendance({
    required String sessionId,
    required String enrollmentId,
    required String attendanceStatus,
    String? notes,
  }) => remoteDataSource.recordAttendance(
    accessToken: _token,
    sessionId: sessionId,
    enrollmentId: enrollmentId,
    attendanceStatus: attendanceStatus,
    notes: notes,
  );

  @override
  Future<Result<TrainingProgress>> getProgress({
    required String enrollmentId,
  }) async {
    final result = await remoteDataSource.getProgress(
      accessToken: _token,
      enrollmentId: enrollmentId,
    );
    return result.map((dto) => dto.toEntity());
  }

  @override
  Future<Result<Map<String, dynamic>>> configurePromotionCriteria({
    required String versionId,
    required Map<String, dynamic> criteria,
  }) => remoteDataSource.configurePromotionCriteria(
    accessToken: _token,
    versionId: versionId,
    criteria: criteria,
  );

  @override
  Future<Result<Map<String, dynamic>>> decidePromotion({
    required String enrollmentId,
    required String outcome,
    required String reason,
    List<Map<String, dynamic>>? evidence,
  }) => remoteDataSource.decidePromotion(
    accessToken: _token,
    enrollmentId: enrollmentId,
    outcome: outcome,
    reason: reason,
    evidence: evidence,
  );

  @override
  Future<Result<Map<String, dynamic>>> decideExperienceRecognition({
    required String membershipId,
    required String outcome,
    required String reason,
    required String experienceSummary,
    required List<Map<String, dynamic>> evidence,
  }) => remoteDataSource.decideExperienceRecognition(
    accessToken: _token,
    membershipId: membershipId,
    outcome: outcome,
    reason: reason,
    experienceSummary: experienceSummary,
    evidence: evidence,
  );

  @override
  Future<Result<Map<String, dynamic>>> getMemberTransitionHistory({
    required String membershipId,
  }) => remoteDataSource.getMemberTransitionHistory(
    accessToken: _token,
    membershipId: membershipId,
  );
}
