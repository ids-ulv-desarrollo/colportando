import 'package:colportando/features/trainings/domain/entities/training_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_progress_dto.freezed.dart';
part 'training_progress_dto.g.dart';

// DTO para deserializar el progreso factual de capacitación desde la API.
@freezed
abstract class TrainingProgressDto with _$TrainingProgressDto {
  const TrainingProgressDto._();

  const factory TrainingProgressDto({
    required String enrollmentId,
    required String membershipId,
    required String programId,
    required String programVersionId,
    required String programName,
    required int versionNumber,
    required String versionLabel,
    required String enrollmentStatus,
    required String memberCondition,
    required int totalSessions,
    required int recordedSessions,
    required int presentSessions,
    required int absentSessions,
    required int excusedSessions,
    double? attendanceRate,
    required String eligibility,
    required bool promotedAutomatically,
  }) = _TrainingProgressDto;

  factory TrainingProgressDto.fromJson(Map<String, dynamic> json) =>
      _$TrainingProgressDtoFromJson(json);

  TrainingProgress toEntity() => TrainingProgress(
    enrollmentId: enrollmentId,
    membershipId: membershipId,
    programId: programId,
    programVersionId: programVersionId,
    programName: programName,
    versionNumber: versionNumber,
    versionLabel: versionLabel,
    enrollmentStatus: enrollmentStatus,
    memberCondition: memberCondition,
    totalSessions: totalSessions,
    recordedSessions: recordedSessions,
    presentSessions: presentSessions,
    absentSessions: absentSessions,
    excusedSessions: excusedSessions,
    attendanceRate: attendanceRate,
    eligibility: eligibility,
    promotedAutomatically: promotedAutomatically,
  );
}
