import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/campaigns/data/repositories/campaign_repository_impl.dart';
import 'package:colportando/features/campaigns/data/sources/campaign_remote_data_source.dart';
import 'package:colportando/features/campaigns/domain/repositories/campaign_repository.dart';
import 'package:colportando/features/campaigns/domain/usecases/campaign_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data source privado para operaciones de campaña.
final _campaignRemoteDataSourceProvider =
    Provider<ICampaignRemoteDataSource>((ref) {
  return CampaignRemoteDataSourceImpl(
    client: ref.watch(apiClientProvider),
  );
});

// Repositorio privado para operaciones de campaña.
final _campaignRepositoryProvider = Provider<ICampaignRepository>((ref) {
  return CampaignRepositoryImpl(
    remoteDataSource: ref.watch(_campaignRemoteDataSourceProvider),
  );
});

// Proveedores públicos de casos de uso para consumo en Notifier.
final createCampaignUsecaseProvider = Provider<CreateCampaignUsecase>((ref) {
  return CreateCampaignUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final changeCampaignStatusUsecaseProvider =
    Provider<ChangeCampaignStatusUsecase>((ref) {
  return ChangeCampaignStatusUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final createCampaignGroupUsecaseProvider =
    Provider<CreateCampaignGroupUsecase>((ref) {
  return CreateCampaignGroupUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final enrollCampaignParticipationUsecaseProvider =
    Provider<EnrollCampaignParticipationUsecase>((ref) {
  return EnrollCampaignParticipationUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final assignGroupAssociateUsecaseProvider =
    Provider<AssignGroupAssociateUsecase>((ref) {
  return AssignGroupAssociateUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final createOperationalFieldUsecaseProvider =
    Provider<CreateOperationalFieldUsecase>((ref) {
  return CreateOperationalFieldUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final requestGroupChangeUsecaseProvider =
    Provider<RequestGroupChangeUsecase>((ref) {
  return RequestGroupChangeUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final resolveGroupChangeUsecaseProvider =
    Provider<ResolveGroupChangeUsecase>((ref) {
  return ResolveGroupChangeUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final createGroupChangeAppealUsecaseProvider =
    Provider<CreateGroupChangeAppealUsecase>((ref) {
  return CreateGroupChangeAppealUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final resolveGroupChangeAppealUsecaseProvider =
    Provider<ResolveGroupChangeAppealUsecase>((ref) {
  return ResolveGroupChangeAppealUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});

final getGroupOverviewUsecaseProvider =
    Provider<GetGroupOverviewUsecase>((ref) {
  return GetGroupOverviewUsecase(
    repository: ref.watch(_campaignRepositoryProvider),
  );
});
