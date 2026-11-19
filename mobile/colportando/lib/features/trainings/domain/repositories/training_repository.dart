import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/trainings/domain/entities/training_progress.dart';

// Contrato de repositorio para el módulo de capacitación (Training).
abstract class ITrainingRepository {
  Future<Result<Map<String, dynamic>>> createProgram({
    required String clubId,
    required String code,
    required String name,
    required String versionLabel,
    String? startsOn,
    String? endsOn,
  });

  Future<Result<Map<String, dynamic>>> createSession({
    required String versionId,
    required String title,
    required String startsAt,
    required String endsAt,
  });

  Future<Result<Map<String, dynamic>>> createEnrollment({
    required String versionId,
    required String membershipId,
  });

  Future<Result<Map<String, dynamic>>> changeSessionStatus({
    required String sessionId,
    required String status,
  });

  Future<Result<Map<String, dynamic>>> recordAttendance({
    required String sessionId,
    required String enrollmentId,
    required String attendanceStatus,
    String? notes,
  });

  Future<Result<TrainingProgress>> getProgress({
    required String enrollmentId,
  });

  Future<Result<Map<String, dynamic>>> configurePromotionCriteria({
    required String versionId,
    required Map<String, dynamic> criteria,
  });

  Future<Result<Map<String, dynamic>>> decidePromotion({
    required String enrollmentId,
    required String outcome,
    required String reason,
    List<Map<String, dynamic>>? evidence,
  });

  Future<Result<Map<String, dynamic>>> decideExperienceRecognition({
    required String membershipId,
    required String outcome,
    required String reason,
    required String experienceSummary,
    required List<Map<String, dynamic>> evidence,
  });

  Future<Result<Map<String, dynamic>>> getMemberTransitionHistory({
    required String membershipId,
  });
}
