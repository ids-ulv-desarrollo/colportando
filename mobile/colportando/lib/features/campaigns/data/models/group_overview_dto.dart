import 'package:colportando/features/campaigns/domain/entities/group_overview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_overview_dto.freezed.dart';
part 'group_overview_dto.g.dart';

// DTO para deserializar el participante en el resumen del grupo.
@freezed
abstract class GroupParticipantDto with _$GroupParticipantDto {
  const GroupParticipantDto._();

  const factory GroupParticipantDto({
    required String participationId,
    required String membershipId,
  }) = _GroupParticipantDto;

  factory GroupParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$GroupParticipantDtoFromJson(json);

  GroupParticipant toEntity() => GroupParticipant(
    participationId: participationId,
    membershipId: membershipId,
  );
}

// DTO para deserializar el campo en el resumen del grupo.
@freezed
abstract class GroupFieldDto with _$GroupFieldDto {
  const GroupFieldDto._();

  const factory GroupFieldDto({
    required String fieldId,
    required String name,
  }) = _GroupFieldDto;

  factory GroupFieldDto.fromJson(Map<String, dynamic> json) =>
      _$GroupFieldDtoFromJson(json);

  GroupField toEntity() => GroupField(
    fieldId: fieldId,
    name: name,
  );
}

// DTO para deserializar el resumen operativo completo del grupo de campaña.
@freezed
abstract class GroupOverviewDto with _$GroupOverviewDto {
  const GroupOverviewDto._();

  const factory GroupOverviewDto({
    required String groupId,
    required String campaignId,
    required String name,
    String? associateParticipationId,
    @Default([]) List<GroupParticipantDto> participants,
    @Default([]) List<GroupFieldDto> fields,
  }) = _GroupOverviewDto;

  factory GroupOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$GroupOverviewDtoFromJson(json);

  GroupOverview toEntity() => GroupOverview(
    groupId: groupId,
    campaignId: campaignId,
    name: name,
    associateParticipationId: associateParticipationId,
    participants: participants.map((p) => p.toEntity()).toList(),
    fields: fields.map((f) => f.toEntity()).toList(),
  );
}
