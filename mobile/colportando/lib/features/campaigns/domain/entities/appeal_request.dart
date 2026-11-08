class AppealRequest {
  final String id;
  final String userId;
  final String userName;
  final String currentGroup;
  final DateTime realizationDate;
  final String requestedGroup;
  final String reason;
  final String status;
  final DateTime? responseDate;
  final DateTime createdAt;

  const AppealRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.currentGroup,
    required this.realizationDate,
    required this.requestedGroup,
    required this.reason,
    required this.status,
    this.responseDate,
    required this.createdAt,
  });

  String get formattedRealizationDate {
    final day = realizationDate.day.toString().padLeft(2, "0");
    final month = realizationDate.month.toString().padLeft(2, "0");
    return "$day/$month/${realizationDate.year}";
  }

  String? get formattedResponseDate {
    if (responseDate == null) return null;
    final day = responseDate!.day.toString().padLeft(2, "0");
    final month = responseDate!.month.toString().padLeft(2, "0");
    return "$day/$month/${responseDate!.year}";
  }

  AppealRequest copyWith({String? status, DateTime? responseDate}) {
    return AppealRequest(
      id: id,
      userId: userId,
      userName: userName,
      currentGroup: currentGroup,
      realizationDate: realizationDate,
      requestedGroup: requestedGroup,
      reason: reason,
      status: status ?? this.status,
      responseDate: responseDate ?? this.responseDate,
      createdAt: createdAt,
    );
  }
}
