import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/campaigns/domain/entities/campaign.dart';

abstract class ICampaignRepository{
  Future<Result<void>> createCampaign({
    required String clubId,
    required String name,
    required String description,
    required DateTime startsOn,
    required DateTime endsOn,
  });

  Future<Result<Campaign>> status({
    required String campaignId,
    required String idempotency_key,
    required String status,
  });
}