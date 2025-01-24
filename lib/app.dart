import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'config/bindings.dart';
import 'imports.dart';
import 'screens/login/views/index.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final theme = Get.put(ThemeService());
  final settings = Get.put(SettingsService());

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    try {
      await BindingsConfig().dependencies();
      FlutterNativeSplash.remove();
      if (Get.find<AuthService>().isSignedIn.value) {
        Get.offAll(() => DefaultLayout(), transition: Transition.fadeIn);
        return;
      }
      Get.offAll(() => LoginView(), transition: Transition.fadeIn);
    } on Error catch (error) {
      logger.e(error, stackTrace: error.stackTrace);
      Get.dialog(
        AlertDialog(
          title: Text(t.error),
          content: Text(t.error_message(error.toString())),
          actions: [
            TextButton(
              onPressed: () => Get.close(),
              child: Text(t.quit),
            )
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(context) {
    final seedColor = theme.color.value;
    final darkTheme = getThemeData(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    final lightTheme = getThemeData(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return GetMaterialApp(
      theme: lightTheme.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(lightTheme.textTheme),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(darkTheme.textTheme),
      ),
      themeMode: theme.activeMode.value.buitin,
      locale: settings.language.value.locale,
      fallbackLocale: Language.en.locale,
      defaultTransition:
          GetPlatform.isDesktop ? Transition.downToUp : Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
