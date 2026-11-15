import 'package:colportando/features/groups/domain/entities/colportor_group.dart';
import 'package:colportando/features/groups/domain/entities/group_zone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsNotifier extends Notifier<List<ColportorGroup>> {
  @override
  List<ColportorGroup> build() => const [];

  void createGroup({required String name, required String assignedZone}) {
    final group = ColportorGroup(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      assignedZone: assignedZone,
    );
    state = [...state, group];
  }

  void deleteGroup(String groupId) {
    state = state.where((group) => group.id != groupId).toList();
  }

  void updateDescription({
    required String groupId,
    required String description,
  }) {
    _updateGroup(
      groupId,
      (group) => group.copyWith(description: description.trim()),
    );
  }

  void updateGroupDetails({
    required String groupId,
    required String name,
    required String description,
    String? imagePath,
    bool clearImagePath = false,
  }) {
    _updateGroup(
      groupId,
      (group) => group.copyWith(
        name: name.trim(),
        description: description.trim(),
        imagePath: imagePath,
        clearImagePath: clearImagePath,
      ),
    );
  }

  void updateImagePath({required String groupId, required String imagePath}) {
    _updateGroup(groupId, (group) => group.copyWith(imagePath: imagePath));
  }

  void removeImage(String groupId) {
    _updateGroup(groupId, (group) => group.copyWith(clearImagePath: true));
  }

  bool addColporter({required String groupId, required String name}) {
    final normalizedName = name.trim();
    final groupIndex = state.indexWhere((group) => group.id == groupId);
    if (groupIndex == -1 || normalizedName.isEmpty) return false;

    final group = state[groupIndex];
    final alreadyAdded = group.colporters.any(
      (colporter) => colporter.toLowerCase() == normalizedName.toLowerCase(),
    );
    if (alreadyAdded) return false;

    state = [
      for (final currentGroup in state)
        if (currentGroup.id == groupId)
          currentGroup.copyWith(
            colporters: [...currentGroup.colporters, normalizedName],
          )
        else
          currentGroup,
    ];
    return true;
  }

  void removeColporter({required String groupId, required String name}) {
    state = [
      for (final group in state)
        if (group.id == groupId)
          group.copyWith(
            colporters: group.colporters
                .where((colporter) => colporter != name)
                .toList(),
          )
        else
          group,
    ];
  }

  bool addAssociate({required String groupId, required String name}) {
    final normalizedName = name.trim();
    final groupIndex = state.indexWhere((group) => group.id == groupId);
    if (groupIndex == -1 || normalizedName.isEmpty) return false;
    if (state[groupIndex].associate != null) return false;

    _updateGroup(groupId, (group) => group.copyWith(associate: normalizedName));
    return true;
  }

  void removeAssociate(String groupId) {
    _updateGroup(groupId, (group) => group.copyWith(clearAssociate: true));
  }

  void _updateGroup(
    String groupId,
    ColportorGroup Function(ColportorGroup) update,
  ) {
    state = [
      for (final group in state)
        if (group.id == groupId) update(group) else group,
    ];
  }
}

final groupsProvider = NotifierProvider<GroupsNotifier, List<ColportorGroup>>(
  GroupsNotifier.new,
);

class ZonesNotifier extends Notifier<List<GroupZone>> {
  @override
  List<GroupZone> build() => const [];

  bool createZone(String name) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty ||
        state.any(
          (zone) => zone.name.toLowerCase() == normalizedName.toLowerCase(),
        )) {
      return false;
    }

    final now = DateTime.now();
    state = [
      ...state,
      GroupZone(
        id: now.microsecondsSinceEpoch.toString(),
        name: normalizedName,
        createdAt: now,
      ),
    ];
    return true;
  }
}

final zonesProvider = NotifierProvider<ZonesNotifier, List<GroupZone>>(
  ZonesNotifier.new,
);
