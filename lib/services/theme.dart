import '/imports.dart';

class ThemeService extends GetxService {
  final logger = Logger();

  final mode = PersistentRxCustom(
    ThemeMode.auto,
    key: 'theme:mode',
    encode: (value) => value.name,
    decode: (value) {
      return ThemeMode.values.byName(value);
    },
  );
  final activeMode = ThemeMode.auto.obs;
  final color = PersistentRxColor(Colors.blue, key: 'theme:color');
  final contrast = PersistentRxDouble(0.0, key: 'theme:contrast');
  final colours = PersistentRxBool(false, key: 'theme:colours');

  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    logger.t('onReady()');

    mode.listen((next) => update());
    activeMode.listen((next) => Get.changeThemeMode(next.buitin));

    _timer = Timer.periodic(Duration(seconds: 1), (e) => update());
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
  }

  Future<ThemeService> init() async {
    logger.i('init()');

    if (mode.value == ThemeMode.auto) {
      update();
    } else {
      activeMode.value = mode.value;
    }

    logger.i('init() => successful');
    return this;
  }

  void update() {
    if (mode.value != ThemeMode.auto) {
      if (activeMode.value == mode.value) return;
      activeMode.value = mode.value;
      return;
    }

    var time = DateTime.now();
    var next =
        time.hour >= 18 || time.hour <= 6 ? ThemeMode.dark : ThemeMode.light;
    if (next == activeMode.value) return;
    activeMode.value = next;
  }
}
