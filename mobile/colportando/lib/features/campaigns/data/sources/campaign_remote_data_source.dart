import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/campaigns/data/models/campaign_dto.dart';

abstract class ICampaignRemoteDataSource {
  Future<Result<void>> createCampaign({
    required String clubId,
    required String name,
    required String description,
    required DateTime startsOn,
    required DateTime endsOn,
  });

  Future<Result<CampaignDto>> status({
    required String campaignId,
    required String idempotency_key,
    required String status,
  });
}

class CampaignRemoteDataSource implements ICampaignRemoteDataSource {
  final ApiClient _apiClient;

  const CampaignRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<void>> createCampaign({
    required String clubId,
    required String name,
    required String description,
    required DateTime startsOn,
    required DateTime endsOn,
  }) => _apiClient.post<void>(
    '/operations/campaign',
    body: {
      'clubId': clubId,
      'name': name,
      'description': description,
      'startsOn': startsOn,
      'endsOn': endsOn,
    },
  );

  @override
  Future<Result<CampaignDto>> status({
    required String campaignId,
    required String idempotency_key,
    required String status,
  }) => _apiClient.put<CampaignDto>(
    '/operations/campaigns/$campaignId/status',
    body: {'campaignId': campaignId, 'idempotency_key': idempotency_key, 'status': status},
    fromJson: (json) => CampaignDto.fromJson(json)
  );
}
