import 'package:universal_io/io.dart' show Cookie, SameSite;
import '../api/agents.dart';
import '../api/auth.dart';
import '../api/canned_responses.dart';
import '../api/contacts.dart';
import '../api/conversations.dart';
import '../api/custom_attributes.dart';
import '../api/inboxes.dart';
import '../api/labels.dart';
import '../api/macros.dart';
import '../api/notifications.dart';
import '../api/profile.dart';
import '../api/teams.dart';
import '/imports.dart';

class ApiService extends GetxService {
  final _logger = Logger();

  late Dio http;
  late AgentsApi agents;
  late AuthApi auth;
  late CannedResponsesApi cannedResponses;
  late ContactsApi contacts;
  late ConversationsApi conversations;
  late CustomAttributesApi customAttributes;
  late InboxesApi inboxes;
  late LabelsApi labels;
  late MacrosApi macros;
  late NotificationsApi notifications;
  late ProfileApi profile;
  late TeamsApi teams;

  final baseUrl = PersistentRxString(env.API_URL, key: 'api:baseUrl');
  final version = PersistentRxString(env.API_VERSION, key: 'api:version');

  @override
  void onReady() {
    super.onReady();

    baseUrl.listen((next) {
      http.options.baseUrl = getBaseUrl;
      _logger.i('baseUrl changed => ${http.options.baseUrl}');
    });
  }

  DbService? _db;
  DbService get _getDb {
    _db ??= Get.find<DbService>();
    if (_db == null) throw Exception('DbService not found!');
    return _db!;
  }

  AuthService? _auth;
  AuthService get _getAuth {
    _auth ??= Get.find<AuthService>();
    if (_auth == null) throw Exception('AuthService not found!');
    return _auth!;
  }

  String get getBaseUrl {
    return '${baseUrl.value}/api/${version.value}';
  }

  int get account_id => _getAuth.profile.value!.account_id;

  Future<ApiService> init() async {
    http = Dio();

    http.options.headers = {
      'content-type': 'application/json',
      'x-app-version': packageInfo.version,
    };
    http.options.baseUrl = getBaseUrl;
    http.options.connectTimeout = Duration(seconds: env.API_TIMEOUT);

    // capture requests and responses
    http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => _onRequest(options, handler),
        onResponse: (response, handler) => _onResponse(response, handler),
      ),
    );

    // supports reusing connections, header compression, etc.
    http.httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: Duration(seconds: env.API_TIMEOUT),
        onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      ),
    );

    agents = AgentsApi(service: this);
    auth = AuthApi(service: this);
    cannedResponses = CannedResponsesApi(service: this);
    contacts = ContactsApi(service: this);
    conversations = ConversationsApi(service: this);
    customAttributes = CustomAttributesApi(service: this);
    inboxes = InboxesApi(service: this);
    labels = LabelsApi(service: this);
    macros = MacrosApi(service: this);
    notifications = NotificationsApi(service: this);
    profile = ProfileApi(service: this);
    teams = TeamsApi(service: this);

    return this;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      _logger.t('[${options.method}] ${options.uri}');

      // inject account_id
      options.path = options.path.replaceAll('{account_id}', '$account_id');

      // inject cookie
      final cookies = await cookieManager.getCookies(
        url: WebUri.uri(options.uri),
      );

      final flatCookie = cookies.map((e) => '${e.name}=${e.value}').join(';');
      _logger.t('flatCookie:$flatCookie');
      options.headers['cookie'] = flatCookie;

      // inject user-agent
      options.headers['user-agent'] =
          '${packageInfo.appName}/${packageInfo.version}';

      // inject authorization
      final profile = _getAuth.profile.value;
      if (options.uri.toString().contains('/api/') && profile != null) {
        options.headers['api_access_token'] = profile.access_token;
      }
    } on Error catch (error) {
      _logger.e(error, stackTrace: error.stackTrace);
    }

    return handler.next(options);
  }

  Future<void> _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      final setCookies = response.headers['set-cookie'] ?? [];
      final cookies = setCookies.map(Cookie.fromSetCookieValue).toList();

      for (final cookie in cookies) {
        _logger.t('set-cookie ${cookie.name}=${cookie.value}');

        await cookieManager.setCookie(
          url: WebUri.uri(response.requestOptions.uri),
          name: cookie.name,
          value: cookie.value,
          sameSite: (() {
            switch (cookie.sameSite) {
              case SameSite.lax:
                return HTTPCookieSameSitePolicy.LAX;
              case SameSite.strict:
                return HTTPCookieSameSitePolicy.STRICT;
              default:
                return HTTPCookieSameSitePolicy.NONE;
            }
          })(),
          isSecure: cookie.secure,
          expiresDate: cookie.expires?.millisecondsSinceEpoch,
          domain: cookie.domain,
          maxAge: cookie.maxAge,
          isHttpOnly: cookie.httpOnly,
        );
      }
    } on Error catch (error) {
      _logger.e(error, stackTrace: error.stackTrace);
    }

    return handler.next(response);
  }

  Future<Result<ApiInfo>> getInfo({String? baseUrl}) async {
    try {
      final result = await http.get('${baseUrl ?? env.API_URL}/api');
      return ApiInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<CachedRequest?> _getCache({
    required String url,
  }) async {
    var query = await _getDb.database.query(
      'cached_requests',
      where: 'url = ?',
      whereArgs: [url],
    );
    if (query.isEmpty) return null;
    return CachedRequest.fromJson(query.first);
  }

  Future<void> _saveCache({
    required String url,
    required dynamic data,
  }) async {
    await _getDb.database.insert('cached_requests', {
      'url': url,
      'data': jsonEncode(data),
      'createdAt': timestamp(),
    });
  }

  Future<Result<Response<T>>> send<T>(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    void Function(T data)? onCacheHit,
  }) async {
    try {
      options ??= Options();
      options.method = method;

      if (onCacheHit != null) {
        final cached = await _getCache(url: path);
        if (cached != null) {
          try {
            final decoded = jsonDecode(cached.data);
            if (decoded != null) onCacheHit(decoded);
          } on Error catch (error) {
            logger.e(error, stackTrace: error.stackTrace);
          }
        }
      }

      final response = await http.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (onCacheHit != null) _saveCache(url: path, data: response.data);
      return response.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      _logger.e(error, stackTrace: (error as Error).stackTrace);
      return error.toFailure();
    }
  }

  Future<Result<Response<T>>> head<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      send<T>(
        'head',
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

  Future<Result<Response<T>>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    void Function(T data)? onCacheHit,
  }) =>
      send<T>(
        'get',
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onCacheHit: onCacheHit,
      );

  Future<Result<Response<T>>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) =>
      send<T>(
        'put',
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<Result<Response<T>>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) =>
      send<T>(
        'post',
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<Result<Response<T>>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) =>
      send<T>(
        'patch',
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  Future<Result<Response<T>>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      send<T>(
        'delete',
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
}
