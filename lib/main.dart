import 'app.dart';
import 'imports.dart';
import 'package:path/path.dart' as p;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart' as logger;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> loadEnvironments() async {
  var environments = kDebugMode
      ? ['.env.production', '.env.development', '.env']
      : ['.env.production'];
  for (var environment in environments) {
    try {
      await dotenv.load(fileName: environment);
      // ignore: empty_catches
    } catch (error) {}
  }

  env = Dotenv.fromJson(dotenv.env);
  if (kDebugMode) print('environments: ${jsonEncode(dotenv.env)}');
}

void main() async {
  runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // environments
    await loadEnvironments();

    // sentry
    if (env.SENTRY_DNS != null) {
      await SentryFlutter.init(
        (options) {
          options.dsn = env.SENTRY_DNS;
          options.attachScreenshot = true;
          // options.ignoreErrors
        },
      );
    }

    // logger
    final appDocumentsDir = await getApplicationCacheDirectory();
    final logPath = p.join(appDocumentsDir.path, 'logs');
    logger.Logger.level = kDebugMode ? logger.Level.debug : logger.Level.info;
    logger.Logger.defaultPrinter = () {
      return PrettyPrinter();
    };
    logger.Logger.defaultOutput = () {
      return AdvancedFileOutput(
        path: logPath,
        maxFileSizeKB: 4096,
        maxRotatedFilesCount: 5,
      );
    };

    // window
    if (GetPlatform.isDesktop) {
      await windowManager.ensureInitialized();
      final windowOptions = WindowOptions(
        size: const Size(1280, 720),
        minimumSize: const Size(1080, 640),
        center: true,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    // webview
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }

    // preferences
    prefs = await SharedPreferences.getInstance();

    // app
    runApp(SentryWidget(child: App()));
  }, (exception, stackTrace) async {
    Logger().e(exception, stackTrace: stackTrace);
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}
