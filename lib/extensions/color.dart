import '/imports.dart';

extension ColorX on Color {
  String toHexTriplet() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  bool compareTo(Color other) {
    return a == other.a && r == other.r && g == other.g && b == other.b;
  }
}
