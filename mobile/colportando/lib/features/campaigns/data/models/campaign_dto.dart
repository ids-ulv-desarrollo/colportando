import 'package:colportando/features/campaigns/domain/entities/campaign.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign_dto.freezed.dart';
part 'campaign_dto.g.dart';

@freezed
abstract class CampaignDto with _$CampaignDto {
  const CampaignDto._();

  const factory CampaignDto({
    required String clubId,
    required String name,
    String? description,
    required DateTime startsOn,
    required DateTime endsOn,
    @JsonKey(name: "create_at") required DateTime createdAt,
    @JsonKey(name: "delete_at") DateTime? deletedAt,
  }) = _CampaignDto;

  factory CampaignDto.fromJson(Map<String, dynamic> json) => _$CampaignDtoFromJson(json);

  Campaign toEntity() => Campaign(
    clubId: clubId,
    name: name,
    description: description,
    startsOn: startsOn,
    endsOn: endsOn,
    createdAt: createdAt,
    deletedAt: deletedAt,
  );
}