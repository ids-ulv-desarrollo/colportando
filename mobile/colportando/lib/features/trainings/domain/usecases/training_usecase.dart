import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/trainings/domain/entities/training_progress.dart';
import 'package:colportando/features/trainings/domain/repositories/training_repository.dart';

// crea un programa de capacitación y su primera versión para el club.
class CreateTrainingProgramUsecase {
  final ITrainingRepository repository;
  const CreateTrainingProgramUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String clubId,
    required String code,
    required String name,
    required String versionLabel,
    String? startsOn,
    String? endsOn,
  }) => repository.createProgram(
    clubId: clubId,
    code: code,
    name: name,
    versionLabel: versionLabel,
    startsOn: startsOn,
    endsOn: endsOn,
  );
}

// crea una sesión de capacitación con horario definido.
class CreateTrainingSessionUsecase {
  final ITrainingRepository repository;
  const CreateTrainingSessionUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String versionId,
    required String title,
    required String startsAt,
    required String endsAt,
  }) => repository.createSession(
    versionId: versionId,
    title: title,
    startsAt: startsAt,
    endsAt: endsAt,
  );
}

// inscribe la membresía de un aspirante en una versión de programa.
class CreateTrainingEnrollmentUsecase {
  final ITrainingRepository repository;
  const CreateTrainingEnrollmentUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String versionId,
    required String membershipId,
  }) => repository.createEnrollment(
    versionId: versionId,
    membershipId: membershipId,
  );
}

// cambia el estado de una sesión (cerrar o cancelar).
class ChangeTrainingSessionStatusUsecase {
  final ITrainingRepository repository;
  const ChangeTrainingSessionStatusUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String sessionId,
    required String status,
  }) => repository.changeSessionStatus(sessionId: sessionId, status: status);
}

// registra o rectifica asistencia de un aspirante a una sesión.
class RecordTrainingAttendanceUsecase {
  final ITrainingRepository repository;
  const RecordTrainingAttendanceUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String sessionId,
    required String enrollmentId,
    required String attendanceStatus,
    String? notes,
  }) => repository.recordAttendance(
    sessionId: sessionId,
    enrollmentId: enrollmentId,
    attendanceStatus: attendanceStatus,
    notes: notes,
  );
}

// consulta el progreso factual de asistencia del aspirante.
class GetTrainingProgressUsecase {
  final ITrainingRepository repository;
  const GetTrainingProgressUsecase({required this.repository});

  Future<Result<TrainingProgress>> call({required String enrollmentId}) =>
      repository.getProgress(enrollmentId: enrollmentId);
}

// configura criterios oficiales de promoción en una versión de programa.
class ConfigurePromotionCriteriaUsecase {
  final ITrainingRepository repository;
  const ConfigurePromotionCriteriaUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String versionId,
    required Map<String, dynamic> criteria,
  }) => repository.configurePromotionCriteria(
    versionId: versionId,
    criteria: criteria,
  );
}

// aprueba o rechaza explícitamente la promoción de un aspirante.
class DecideTrainingPromotionUsecase {
  final ITrainingRepository repository;
  const DecideTrainingPromotionUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String enrollmentId,
    required String outcome,
    required String reason,
    List<Map<String, dynamic>>? evidence,
  }) => repository.decidePromotion(
    enrollmentId: enrollmentId,
    outcome: outcome,
    reason: reason,
    evidence: evidence,
  );
}

// evalúa y valida experiencia previa de un aspirante.
class DecideExperienceRecognitionUsecase {
  final ITrainingRepository repository;
  const DecideExperienceRecognitionUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({
    required String membershipId,
    required String outcome,
    required String reason,
    required String experienceSummary,
    required List<Map<String, dynamic>> evidence,
  }) => repository.decideExperienceRecognition(
    membershipId: membershipId,
    outcome: outcome,
    reason: reason,
    experienceSummary: experienceSummary,
    evidence: evidence,
  );
}

// consulta historial auditable de condiciones y transiciones.
class GetMemberTransitionHistoryUsecase {
  final ITrainingRepository repository;
  const GetMemberTransitionHistoryUsecase({required this.repository});

  Future<Result<Map<String, dynamic>>> call({required String membershipId}) =>
      repository.getMemberTransitionHistory(membershipId: membershipId);
}
