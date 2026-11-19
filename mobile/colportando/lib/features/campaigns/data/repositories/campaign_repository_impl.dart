import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/campaigns/data/sources/campaign_remote_data_source.dart';
import 'package:colportando/features/campaigns/domain/entities/group_overview.dart';
import 'package:colportando/features/campaigns/domain/repositories/campaign_repository.dart';

// Implementación concreta del repositorio de operaciones de campaña.
class CampaignRepositoryImpl implements ICampaignRepository {
  final ICampaignRemoteDataSource remoteDataSource;
  const CampaignRepositoryImpl({required this.remoteDataSource});

  String get _token => SecureStorage.accessToken ?? '';

  @override
  Future<Result<Map<String, dynamic>>> createCampaign({
    required String clubId,
    required String name,
    required String startsOn,
    required String endsOn,
    String? description,
  }) => remoteDataSource.createCampaign(
    accessToken: _token,
    clubId: clubId,
    name: name,
    startsOn: startsOn,
    endsOn: endsOn,
    description: description,
  );

  @override
  Future<Result<Map<String, dynamic>>> changeCampaignStatus({
    required String campaignId,
    required String status,
  }) => remoteDataSource.changeCampaignStatus(
    accessToken: _token,
    campaignId: campaignId,
    status: status,
  );

  @override
  Future<Result<Map<String, dynamic>>> createCampaignGroup({
    required String campaignId,
    required String name,
    String? description,
  }) => remoteDataSource.createCampaignGroup(
    accessToken: _token,
    campaignId: campaignId,
    name: name,
    description: description,
  );

  @override
  Future<Result<Map<String, dynamic>>> enrollParticipation({
    required String campaignId,
    required String membershipId,
    required String groupId,
  }) => remoteDataSource.enrollParticipation(
    accessToken: _token,
    campaignId: campaignId,
    membershipId: membershipId,
    groupId: groupId,
  );

  @override
  Future<Result<Map<String, dynamic>>> assignGroupAssociate({
    required String groupId,
    required String participationId,
    required String reason,
  }) => remoteDataSource.assignGroupAssociate(
    accessToken: _token,
    groupId: groupId,
    participationId: participationId,
    reason: reason,
  );

  @override
  Future<Result<Map<String, dynamic>>> createOperationalField({
    required String campaignId,
    required String groupId,
    required String name,
    String? organization,
    String? description,
    String? territoryNotes,
  }) => remoteDataSource.createOperationalField(
    accessToken: _token,
    campaignId: campaignId,
    groupId: groupId,
    name: name,
    organization: organization,
    description: description,
    territoryNotes: territoryNotes,
  );

  @override
  Future<Result<Map<String, dynamic>>> requestGroupChange({
    required String participationId,
    required String requestedGroupId,
    required String reason,
  }) => remoteDataSource.requestGroupChange(
    accessToken: _token,
    participationId: participationId,
    requestedGroupId: requestedGroupId,
    reason: reason,
  );

  @override
  Future<Result<Map<String, dynamic>>> resolveGroupChange({
    required String requestId,
    required String outcome,
    required String resolution,
  }) => remoteDataSource.resolveGroupChange(
    accessToken: _token,
    requestId: requestId,
    outcome: outcome,
    resolution: resolution,
  );

  @override
  Future<Result<Map<String, dynamic>>> createGroupChangeAppeal({
    required String requestId,
    required String reason,
  }) => remoteDataSource.createGroupChangeAppeal(
    accessToken: _token,
    requestId: requestId,
    reason: reason,
  );

  @override
  Future<Result<Map<String, dynamic>>> resolveGroupChangeAppeal({
    required String appealId,
    required String outcome,
    required String resolution,
  }) => remoteDataSource.resolveGroupChangeAppeal(
    accessToken: _token,
    appealId: appealId,
    outcome: outcome,
    resolution: resolution,
  );

  @override
  Future<Result<GroupOverview>> getGroupOverview({
    required String groupId,
  }) async {
    final result = await remoteDataSource.getGroupOverview(
      accessToken: _token,
      groupId: groupId,
    );
    return result.map((dto) => dto.toEntity());
  }
}
