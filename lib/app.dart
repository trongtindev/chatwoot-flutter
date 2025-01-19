import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/bindings.dart';
import 'imports.dart';
import './translations/index.dart';
import 'screens/login/views/index.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  late ThemeService theme = Get.find<ThemeService>();

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
      if (Get.find<AuthService>().isSignedIn.value) {
        Get.offAll(() => DefaultLayout(), transition: Transition.fadeIn);
        return;
      }
      Get.offAll(() => LoginView(), transition: Transition.fadeIn);
    } catch (error) {
      Get.dialog(
        AlertDialog(
          title: Text('error'.tr),
          content: Text(
            'error_message'.trParams({
              'reason': error.toString(),
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'quit'.tr,
              ),
            )
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(context) {
    var darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: theme.color.value,
        brightness: Brightness.dark,
        contrastLevel: theme.contrast.value,
      ),
    );
    var lightTheme = ThemeData(
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
      themeMode: theme.activeMode.value,
      locale: Locale('en'),
      translations: Translations(),
      fallbackLocale: Locale('en'),
      defaultTransition:
          GetPlatform.isDesktop ? Transition.downToUp : Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
    );
  }
}
