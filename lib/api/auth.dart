import '/imports.dart';

class AuthApi {
  final ApiService service;
  AuthApi({required this.service});

  Future<Result<ProfileInfo>> signIn({
    required String email,
    required String password,
    String? sso_auth_token,
    String? ssoAccountId,
    String? ssoConversationId,
  }) async {
    final path = '${service.baseUrl.value}/auth/sign_in';

    final result = await service.post(
      path,
      data: {
        'email': email,
        'password': password,
        'sso_auth_token': sso_auth_token,
        'ssoAccountId': ssoAccountId,
        'ssoConversationId': ssoConversationId,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    await cookieManager.setCookie(
      url: WebUri.uri(result.getOrThrow().requestOptions.uri),
      name: 'cw_d_session_info',
      value: Uri.encodeComponent(jsonEncode(result.getOrThrow().headers.map)),
    );

    return ProfileInfo.fromJson(data).toSuccess();
  }

  Future<Result<String>> resetPassword({
    required String email,
  }) async {
    final path = '${service.baseUrl.value}/auth/password';

    final result = await service.post<String>(
      path,
      data: {'email': email},
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return '$data'.toSuccess();
  }
}
