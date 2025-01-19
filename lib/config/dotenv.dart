class Dotenv {
  // api
  String API_URL;
  String API_VERSION;
  int API_TIMEOUT;
  int API_RETRIES;

  // app
  String APP_NAME;

  // google
  String GOOGLE_ANDROID_SERVICES_FILE;
  String IOS_ANDROID_SERVICES_FILE;

  // sentry
  String? SENTRY_DNS;

  Dotenv({
    // api
    required this.API_URL,
    required this.API_VERSION,
    required this.API_TIMEOUT,
    required this.API_RETRIES,

    // app
    required this.APP_NAME,

    // google
    required this.GOOGLE_ANDROID_SERVICES_FILE,
    required this.IOS_ANDROID_SERVICES_FILE,

    // sentry
    this.SENTRY_DNS,
  });

  factory Dotenv.fromJson(Map<String, dynamic> env) {
    return Dotenv(
      // api
      API_URL: env['API_URL'],
      API_VERSION: env['API_VERSION'],
      API_TIMEOUT: int.parse(env['API_TIMEOUT']),
      API_RETRIES: int.parse(env['API_RETRIES']),

      // app
      APP_NAME: env['APP_NAME'],

      // google
      GOOGLE_ANDROID_SERVICES_FILE: env['GOOGLE_ANDROID_SERVICES_FILE'],
      IOS_ANDROID_SERVICES_FILE: env['IOS_ANDROID_SERVICES_FILE'],

      // sentry
      SENTRY_DNS: env['SENTRY_DNS'],
    );
  }
}

late Dotenv env;
