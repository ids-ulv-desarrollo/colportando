import 'package:equatable/equatable.dart';

// Entidad que representa el progreso factual de asistencia del aspirante.
class TrainingProgress extends Equatable {
  final String enrollmentId;
  final String membershipId;
  final String programId;
  final String programVersionId;
  final String programName;
  final int versionNumber;
  final String versionLabel;
  final String enrollmentStatus;
  final String memberCondition;
  final int totalSessions;
  final int recordedSessions;
  final int presentSessions;
  final int absentSessions;
  final int excusedSessions;
  final double? attendanceRate;
  final String eligibility;
  final bool promotedAutomatically;

  const TrainingProgress({
    required this.enrollmentId,
    required this.membershipId,
    required this.programId,
    required this.programVersionId,
    required this.programName,
    required this.versionNumber,
    required this.versionLabel,
    required this.enrollmentStatus,
    required this.memberCondition,
    required this.totalSessions,
    required this.recordedSessions,
    required this.presentSessions,
    required this.absentSessions,
    required this.excusedSessions,
    this.attendanceRate,
    required this.eligibility,
    required this.promotedAutomatically,
  });

  @override
  List<Object?> get props => [
    enrollmentId,
    membershipId,
    programId,
    programVersionId,
    programName,
    versionNumber,
    versionLabel,
    enrollmentStatus,
    memberCondition,
    totalSessions,
    recordedSessions,
    presentSessions,
    absentSessions,
    excusedSessions,
    attendanceRate,
    eligibility,
    promotedAutomatically,
  ];
}
