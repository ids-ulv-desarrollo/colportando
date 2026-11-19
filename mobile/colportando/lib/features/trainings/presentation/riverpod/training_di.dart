import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/trainings/data/repositories/training_repository_impl.dart';
import 'package:colportando/features/trainings/data/sources/training_remote_data_source.dart';
import 'package:colportando/features/trainings/domain/repositories/training_repository.dart';
import 'package:colportando/features/trainings/domain/usecases/training_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data source privado para capacitación.
final _trainingRemoteDataSourceProvider =
    Provider<ITrainingRemoteDataSource>((ref) {
  return TrainingRemoteDataSourceImpl(
    client: ref.watch(apiClientProvider),
  );
});

// Repositorio privado para capacitación.
final _trainingRepositoryProvider = Provider<ITrainingRepository>((ref) {
  return TrainingRepositoryImpl(
    remoteDataSource: ref.watch(_trainingRemoteDataSourceProvider),
  );
});

// Proveedores públicos de casos de uso para consumo en Notifier.
final createTrainingProgramUsecaseProvider =
    Provider<CreateTrainingProgramUsecase>((ref) {
  return CreateTrainingProgramUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final createTrainingSessionUsecaseProvider =
    Provider<CreateTrainingSessionUsecase>((ref) {
  return CreateTrainingSessionUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final createTrainingEnrollmentUsecaseProvider =
    Provider<CreateTrainingEnrollmentUsecase>((ref) {
  return CreateTrainingEnrollmentUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final changeTrainingSessionStatusUsecaseProvider =
    Provider<ChangeTrainingSessionStatusUsecase>((ref) {
  return ChangeTrainingSessionStatusUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final recordTrainingAttendanceUsecaseProvider =
    Provider<RecordTrainingAttendanceUsecase>((ref) {
  return RecordTrainingAttendanceUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final getTrainingProgressUsecaseProvider =
    Provider<GetTrainingProgressUsecase>((ref) {
  return GetTrainingProgressUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final configurePromotionCriteriaUsecaseProvider =
    Provider<ConfigurePromotionCriteriaUsecase>((ref) {
  return ConfigurePromotionCriteriaUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final decideTrainingPromotionUsecaseProvider =
    Provider<DecideTrainingPromotionUsecase>((ref) {
  return DecideTrainingPromotionUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final decideExperienceRecognitionUsecaseProvider =
    Provider<DecideExperienceRecognitionUsecase>((ref) {
  return DecideExperienceRecognitionUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});

final getMemberTransitionHistoryUsecaseProvider =
    Provider<GetMemberTransitionHistoryUsecase>((ref) {
  return GetMemberTransitionHistoryUsecase(
    repository: ref.watch(_trainingRepositoryProvider),
  );
});
