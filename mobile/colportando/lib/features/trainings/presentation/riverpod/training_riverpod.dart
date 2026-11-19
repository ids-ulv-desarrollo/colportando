import 'package:colportando/features/trainings/domain/entities/training_progress.dart';
import 'package:colportando/features/trainings/presentation/riverpod/training_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_riverpod.freezed.dart';

// Estado inmutable de capacitación.
@freezed
abstract class TrainingState with _$TrainingState {
  const factory TrainingState({
    @Default(false) bool isLoading,
    String? errorMessage,
    TrainingProgress? progress,
  }) = _TrainingState;
}

// Notificador que gestiona el estado y las acciones del módulo de capacitación.
class TrainingNotifier extends Notifier<TrainingState> {
  @override
  TrainingState build() => const TrainingState();

  // Crea un programa formativo y su versión inicial para el club.
  Future<Map<String, dynamic>?> createProgram({
    required String clubId,
    required String code,
    required String name,
    required String versionLabel,
    String? startsOn,
    String? endsOn,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createTrainingProgramUsecaseProvider)(
      clubId: clubId,
      code: code,
      name: name,
      versionLabel: versionLabel,
      startsOn: startsOn,
      endsOn: endsOn,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Crea una sesión de capacitación con horario definido.
  Future<Map<String, dynamic>?> createSession({
    required String versionId,
    required String title,
    required String startsAt,
    required String endsAt,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createTrainingSessionUsecaseProvider)(
      versionId: versionId,
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Inscribe una membresía en una versión de programa.
  Future<Map<String, dynamic>?> createEnrollment({
    required String versionId,
    required String membershipId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createTrainingEnrollmentUsecaseProvider)(
      versionId: versionId,
      membershipId: membershipId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Cierra o cancela una sesión de capacitación.
  Future<Map<String, dynamic>?> changeSessionStatus({
    required String sessionId,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(changeTrainingSessionStatusUsecaseProvider)(
      sessionId: sessionId,
      status: status,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Registra o rectifica asistencia de un aspirante a una sesión.
  Future<Map<String, dynamic>?> recordAttendance({
    required String sessionId,
    required String enrollmentId,
    required String attendanceStatus,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(recordTrainingAttendanceUsecaseProvider)(
      sessionId: sessionId,
      enrollmentId: enrollmentId,
      attendanceStatus: attendanceStatus,
      notes: notes,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Consulta el progreso factual de asistencia del aspirante.
  Future<TrainingProgress?> getProgress({
    required String enrollmentId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getTrainingProgressUsecaseProvider)(
      enrollmentId: enrollmentId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
      progress: result.data,
    );
    return result.data;
  }

  // Configura los criterios oficiales requeridos para graduar en la versión.
  Future<Map<String, dynamic>?> configurePromotionCriteria({
    required String versionId,
    required Map<String, dynamic> criteria,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(configurePromotionCriteriaUsecaseProvider)(
      versionId: versionId,
      criteria: criteria,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Aprueba o rechaza explícitamente la promoción del aspirante.
  Future<Map<String, dynamic>?> decidePromotion({
    required String enrollmentId,
    required String outcome,
    required String reason,
    List<Map<String, dynamic>>? evidence,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(decideTrainingPromotionUsecaseProvider)(
      enrollmentId: enrollmentId,
      outcome: outcome,
      reason: reason,
      evidence: evidence,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Valida y acredita experiencia previa de un aspirante.
  Future<Map<String, dynamic>?> decideExperienceRecognition({
    required String membershipId,
    required String outcome,
    required String reason,
    required String experienceSummary,
    required List<Map<String, dynamic>> evidence,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(decideExperienceRecognitionUsecaseProvider)(
      membershipId: membershipId,
      outcome: outcome,
      reason: reason,
      experienceSummary: experienceSummary,
      evidence: evidence,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Consulta el historial auditable de condiciones y transiciones del aspirante.
  Future<Map<String, dynamic>?> getMemberTransitionHistory({
    required String membershipId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getMemberTransitionHistoryUsecaseProvider)(
      membershipId: membershipId,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }
}

// Proveedor global para el módulo de capacitación.
final trainingProvider =
    NotifierProvider<TrainingNotifier, TrainingState>(() {
  return TrainingNotifier();
});
