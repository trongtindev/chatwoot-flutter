import 'dart:math';

String getUuid() {
  return 'xxxxxxxx4xxx'.replaceAllMapped(RegExp(r'[xy]'), (Match match) {
    final String c = match[0]!;
    final int r = (Random().nextInt(16)).floor();
    final int v = c == 'x' ? r : (r & 0x3) | 0x8;
    return v.toRadixString(16);
  });
}
