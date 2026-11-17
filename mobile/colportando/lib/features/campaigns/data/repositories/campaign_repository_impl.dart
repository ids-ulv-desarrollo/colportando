import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/campaigns/data/sources/campaign_remote_data_source.dart';
import 'package:colportando/features/campaigns/domain/entities/campaign.dart';
import 'package:colportando/features/campaigns/domain/repositories/campaign_repository.dart';

class CampaignRepositoryImpl implements ICampaignRepository {
  final ICampaignRemoteDataSource remoteDataSource;

  const CampaignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<void>> createCampaign({
    required String clubId,
    required String name,
    required String description,
    required DateTime startsOn,
    required DateTime endsOn,
  }) async {
    return await remoteDataSource.createCampaign(
      clubId: clubId,
      name: name,
      description: description,
      startsOn: startsOn,
      endsOn: endsOn,
    );
  }

  @override
  Future<Result<Campaign>> status({
    required String campaignId,
    required String idempotency_key,
    required String status,
  }) async {
    final result = await remoteDataSource.status(campaignId: campaignId, idempotency_key: idempotency_key, status: status);

    return result.map((dto) => dto.toEntity());
  }
}
