import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/auth/data/models/user_dto.dart';

abstract class IAuthRemoteDataSource {
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Result<Map<String, dynamic>>> refreshSession({
    required String refreshToken,
  });

  Future<Result<void>> logout({required String refreshToken});

  Future<Result<UserDto>> getMe({required String accessToken});

  Future<Result<void>> requestEmailVerification({required String email});

  Future<Result<void>> confirmEmailVerification({
    required String email,
    required String code,
  });

  Future<Result<void>> requestPasswordReset({required String email});

  Future<Result<void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<Result<Map<String, dynamic>>> createInvitation({
    required String accessToken,
    required String clubId,
    required String email,
  });

  Future<Result<Map<String, dynamic>>> inspectInvitation({
    required String email,
    required String code,
  });

  Future<Result<Map<String, dynamic>>> acceptInvitation({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
  });
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/auth/login',
    body: {'email': email, 'password': password, 'clientName': 'Mobile'},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> refreshSession({
    required String refreshToken,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/auth/refresh',
    body: {'refreshToken': refreshToken},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<void>> logout({required String refreshToken}) => _apiClient
      .post<void>('/auth/logout', body: {'refreshToken': refreshToken});

  @override
  Future<Result<UserDto>> getMe({required String accessToken}) =>
      _apiClient.get<UserDto>(
        '/auth/me',
        token: accessToken,
        fromJson: (json) => UserDto.fromJson(json),
      );

  @override
  Future<Result<void>> requestEmailVerification({required String email}) =>
      _apiClient.post<void>(
        '/auth/email-verification/request',
        body: {'email': email},
      );

  @override
  Future<Result<void>> confirmEmailVerification({
    required String email,
    required String code,
  }) => _apiClient.post<void>(
    '/auth/email-verification/confirm',
    body: {'email': email, 'code': code},
  );

  @override
  Future<Result<void>> requestPasswordReset({required String email}) =>
      _apiClient.post<void>(
        '/auth/password-reset/request',
        body: {'email': email},
      );

  @override
  Future<Result<void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) => _apiClient.post<void>(
    '/auth/password-reset/confirm',
    body: {'email': email, 'code': code, 'newPassword': newPassword},
  );

  @override
  Future<Result<Map<String, dynamic>>> createInvitation({
    required String accessToken,
    required String clubId,
    required String email,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/auth/invitations',
    token: accessToken,
    body: {'clubId': clubId, 'email': email},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> inspectInvitation({
    required String email,
    required String code,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/auth/invitations/inspect',
    body: {'email': email, 'code': code},
    fromJson: (json) => json as Map<String, dynamic>,
  );

  @override
  Future<Result<Map<String, dynamic>>> acceptInvitation({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
  }) => _apiClient.post<Map<String, dynamic>>(
    '/auth/invitations/accept',
    body: {
      'email': email,
      'code': code,
      'password': password,
      'givenNames': givenNames,
      'familyName': familyName,
      'secondFamilyName': ?secondFamilyName,
      'phoneE164': ?phoneE164,
    },
    fromJson: (json) => json as Map<String, dynamic>,
  );
}
