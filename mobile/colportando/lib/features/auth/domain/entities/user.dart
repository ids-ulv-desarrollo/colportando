import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String accountId;
  final String email;
  final String status;
  final String sessionId;

  const User({
    required this.accountId,
    required this.email,
    required this.status,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [accountId, email, status, sessionId];
}
