import 'package:colportando/features/campaigns/domain/entities/appeal_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const unauthenticatedAppealUserId = "local-test-user";

class AppealsNotifier extends Notifier<List<AppealRequest>> {
  @override
  List<AppealRequest> build() => const [];

  void createAppeal({
    required String id,
    required String userId,
    required String userName,
    required String currentGroup,
    required DateTime realizationDate,
    required String requestedGroup,
    required String reason,
  }) {
    final now = DateTime.now();
    final appeal = AppealRequest(
      id: id,
      userId: userId,
      userName: userName,
      currentGroup: currentGroup,
      realizationDate: realizationDate,
      requestedGroup: requestedGroup,
      reason: reason,
      status: "Pendiente",
      createdAt: now,
    );
    state = [...state, appeal];
  }

  bool updateStatus(String appealId, String status) {
    if (status != "Aceptada" && status != "Rechazada") return false;

    final appealIndex = state.indexWhere((appeal) => appeal.id == appealId);
    if (appealIndex == -1 || state[appealIndex].status != "Pendiente") {
      return false;
    }

    final responseDate = DateTime.now();
    state = [
      for (final appeal in state)
        if (appeal.id == appealId)
          appeal.copyWith(status: status, responseDate: responseDate)
        else
          appeal,
    ];
    return true;
  }
}

final appealsProvider = NotifierProvider<AppealsNotifier, List<AppealRequest>>(
  AppealsNotifier.new,
);
