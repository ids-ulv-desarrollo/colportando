import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/trainings/data/models/training_progress_dto.dart';

// Contrato de la fuente de datos remota para el módulo de capacitación (Training).
abstract class ITrainingRemoteDataSource {
  Future<Result<Map<String, dynamic>>> createProgram({
    required String accessToken,
    required String clubId,
    required String code,
    required String name,
    required String versionLabel,
    String? startsOn,
    String? endsOn,
  });

  Future<Result<Map<String, dynamic>>> createSession({
    required String accessToken,
    required String versionId,
    required String title,
    required String startsAt,
    required String endsAt,
  });

  Future<Result<Map<String, dynamic>>> createEnrollment({
    required String accessToken,
    required String versionId,
    required String membershipId,
  });

  Future<Result<Map<String, dynamic>>> changeSessionStatus({
    required String accessToken,
    required String sessionId,
    required String status,
  });

  Future<Result<Map<String, dynamic>>> recordAttendance({
    required String accessToken,
    required String sessionId,
    required String enrollmentId,
    required String attendanceStatus,
    String? notes,
  });

  Future<Result<TrainingProgressDto>> getProgress({
    required String accessToken,
    required String enrollmentId,
  });

  Future<Result<Map<String, dynamic>>> configurePromotionCriteria({
    required String accessToken,
    required String versionId,
    required Map<String, dynamic> criteria,
  });

  Future<Result<Map<String, dynamic>>> decidePromotion({
    required String accessToken,
    required String enrollmentId,
    required String outcome,
    required String reason,
    List<Map<String, dynamic>>? evidence,
  });

  Future<Result<Map<String, dynamic>>> decideExperienceRecognition({
    required String accessToken,
    required String membershipId,
    required String outcome,
    required String reason,
    required String experienceSummary,
    required List<Map<String, dynamic>> evidence,
  });

  Future<Result<Map<String, dynamic>>> getMemberTransitionHistory({
    required String accessToken,
    required String membershipId,
  });
}

// Implementación concreta que se comunica con el backend mediante ApiClient.
class TrainingRemoteDataSourceImpl implements ITrainingRemoteDataSource {
  final ApiClient client;
  TrainingRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<Map<String, dynamic>>> createProgram({
    required String accessToken,
    required String clubId,
    required String code,
    required String name,
    required String versionLabel,
    String? startsOn,
    String? endsOn,
  }) => client.post<Map<String, dynamic>>(
    '/training/programs',
    token: accessToken,
    body: {
      'clubId': clubId,
      'code': code,
      'name': name,
      'versionLabel': versionLabel,
      if (startsOn != null) 'startsOn': startsOn,
      if (endsOn != null) 'endsOn': endsOn,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createSession({
    required String accessToken,
    required String versionId,
    required String title,
    required String startsAt,
    required String endsAt,
  }) => client.post<Map<String, dynamic>>(
    '/training/program-versions/$versionId/sessions',
    token: accessToken,
    body: {
      'title': title,
      'startsAt': startsAt,
      'endsAt': endsAt,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> createEnrollment({
    required String accessToken,
    required String versionId,
    required String membershipId,
  }) => client.post<Map<String, dynamic>>(
    '/training/program-versions/$versionId/enrollments',
    token: accessToken,
    body: {'membershipId': membershipId},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> changeSessionStatus({
    required String accessToken,
    required String sessionId,
    required String status,
  }) => client.put<Map<String, dynamic>>(
    '/training/sessions/$sessionId/status',
    token: accessToken,
    body: {'status': status},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> recordAttendance({
    required String accessToken,
    required String sessionId,
    required String enrollmentId,
    required String attendanceStatus,
    String? notes,
  }) => client.put<Map<String, dynamic>>(
    '/training/sessions/$sessionId/attendance/$enrollmentId',
    token: accessToken,
    body: {
      'attendanceStatus': attendanceStatus,
      if (notes != null) 'notes': notes,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<TrainingProgressDto>> getProgress({
    required String accessToken,
    required String enrollmentId,
  }) => client.get<TrainingProgressDto>(
    '/training/enrollments/$enrollmentId/progress',
    token: accessToken,
    fromJson: (json) => TrainingProgressDto.fromJson(json as Map<String, dynamic>),
  );

  @override
  Future<Result<Map<String, dynamic>>> configurePromotionCriteria({
    required String accessToken,
    required String versionId,
    required Map<String, dynamic> criteria,
  }) => client.put<Map<String, dynamic>>(
    '/training/program-versions/$versionId/promotion-criteria',
    token: accessToken,
    body: {'criteria': criteria},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> decidePromotion({
    required String accessToken,
    required String enrollmentId,
    required String outcome,
    required String reason,
    List<Map<String, dynamic>>? evidence,
  }) => client.post<Map<String, dynamic>>(
    '/training/enrollments/$enrollmentId/promotion-decisions',
    token: accessToken,
    body: {
      'outcome': outcome,
      'reason': reason,
      if (evidence != null) 'evidence': evidence,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> decideExperienceRecognition({
    required String accessToken,
    required String membershipId,
    required String outcome,
    required String reason,
    required String experienceSummary,
    required List<Map<String, dynamic>> evidence,
  }) => client.post<Map<String, dynamic>>(
    '/training/memberships/$membershipId/experience-recognitions',
    token: accessToken,
    body: {
      'outcome': outcome,
      'reason': reason,
      'experienceSummary': experienceSummary,
      'evidence': evidence,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> getMemberTransitionHistory({
    required String accessToken,
    required String membershipId,
  }) => client.get<Map<String, dynamic>>(
    '/training/memberships/$membershipId/transition-history',
    token: accessToken,
    fromJson: (json) => json as Map<String, dynamic>,
  );
}
