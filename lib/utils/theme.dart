import '../imports.dart';

ThemeData getThemeData({
  required Color seedColor,
  required brightness,
}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ),
  );
}
