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

  @override
  void initState() {
    super.initState();
    theme.color.listen((next) {
      if (kDebugMode) print('color:$next');
      setState(() {});
    });
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
    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: theme.color.value,
        brightness: Brightness.dark,
        contrastLevel: theme.contrast.value,
      ),
    );
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: theme.color.value,
        brightness: Brightness.light,
        contrastLevel: theme.contrast.value,
      ),
    );

    return GetMaterialApp(
      theme: lightTheme.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(lightTheme.textTheme),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(darkTheme.textTheme),
      ),
      themeMode: theme.activeMode.value.buitin,
      locale: Locale('en'),
      fallbackLocale: Locale('en'),
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
