import 'package:package_info_plus/package_info_plus.dart';
import '/imports.dart';

class ApiService extends GetxService {
  final _logger = Logger();

  AuthService? _auth;
  AuthService get _getAuth {
    _auth ??= Get.find<AuthService>();
    if (_auth == null) throw Exception('AuthService not found!');
    return _auth!;
  }

  late Dio _http;
  late PackageInfo _packageInfo;

  final baseUrl = PersistentRxString(env.API_URL, key: 'api:baseUrl');

  @override
  void onReady() {
    super.onReady();

    baseUrl.listen((next) {
      _http.options.baseUrl = getBaseUrl;
      _logger.i('baseUrl changed => ${_http.options.baseUrl}');
    });
  }

  String get getBaseUrl {
    return '${baseUrl.value}/api/${env.API_VERSION}';
  }

  Future<ApiService> init() async {
    _logger.i('init() baseUrl:$getBaseUrl');

    _packageInfo = await PackageInfo.fromPlatform();

    _http = Dio();
    _http.options.headers = {
      'content-type': 'application/json',
      'x-app-version': _packageInfo.version,
    };
    _http.options.baseUrl = getBaseUrl;
    _http.options.connectTimeout = Duration(seconds: env.API_TIMEOUT);
    _http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => _onRequest(options, handler),
        onResponse: (response, handler) {
          if (kDebugMode) {
            var options = response.requestOptions;
            print('${options.method} ${options.uri}');
            print(response.data);
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.w(error);
          if (kDebugMode && error.response != null) {
            print('${error.requestOptions.method} ${error.requestOptions.uri}');
            print(error.response?.data);
          }
          return handler.next(error);
        },
      ),
    );

    _logger.i('init() => successful');
    return this;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // inject user-agent
    options.headers['user-agent'] =
        '${_packageInfo.appName}/${_packageInfo.version}';

    // inject authorization
    var profile = _getAuth.profile.value;
    if (options.uri.toString().contains('/api/') && profile != null) {
      options.headers['api_access_token'] = profile.access_token;
    }

    return handler.next(options);
  }

  Future<Result<ApiInfo>> getInfo({String? baseUrl}) async {
    try {
      var result = await _http.get('${baseUrl ?? env.API_URL}/api');
      return ApiInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error);
      return error.toFailure();
    }
  }

  Future<Result<ProfileInfo>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var result = await _http.post('${baseUrl.value}/auth/sign_in', data: {
        'email': email,
        'password': password,
      });
      print('ok2');
      print(result.data);
      return ProfileInfo.fromJson(result.data['data']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error);
      return error.toFailure();
    }
  }

  Future<Result<ProfileInfo>> getProfile() async {
    try {
      var result = await _http.get('${baseUrl.value}/profile');
      return ProfileInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error);
      return error.toFailure();
    }
  }

  Future<Result<ListConversationResult>> listConversations({
    required int account_id,
    ConversationStatus? status,
    int? assignee_type_id,
    SortType? sort_order,
    AssigneeType? assignee_type,
  }) async {
    try {
      var result = await _http.get(
        '/accounts/$account_id/conversations',
        queryParameters: {
          'status': status?.name,
          'assignee_type_id': assignee_type_id ?? 0,
          'sort_order': sort_order?.name,
          'assignee_type': assignee_type?.name,
        },
      );
      return ListConversationResult.fromJson(result.data['data']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error);
      return error.toFailure();
    }
  }

  Future<Result<ListNotificationResult>> listNotifications({
    required int account_id,
    List<NotificationStatus>? includes,
  }) async {
    try {
      var result = await _http.get(
        '/accounts/$account_id/notifications',
        queryParameters: {
          'includes': includes?.map((e) => e.name),
        },
      );
      return ListNotificationResult.fromJson(result.data['data']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error);
      return error.toFailure();
    }
  }

  Future<Result<ListContactResult>> listContacts({
    required int account_id,
    int? page,
  }) async {
    try {
      var result = await _http.get(
        '/accounts/$account_id/contacts',
        queryParameters: {
          'page': page ?? 1,
        },
      );
      return ListContactResult.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error);
      return error.toFailure();
    }
  }
}
