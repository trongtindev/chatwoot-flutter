import '/imports.dart';

class PersistentRx<T> extends Rx<T> {
  final String key;

  PersistentRx(T initial, {required this.key}) : super(initial) {
    if (prefs.containsKey(key)) {
      value = jsonDecode(prefs.getString(key)!) as T;
    } else {
      value = initial;
    }
    ever(this, (value) => prefs.setString(key, jsonEncode(value)));
  }
}

class PersistentRxn<T> extends Rxn<T> {
  final String key;

  PersistentRxn({required this.key, T? initial}) : super(initial) {
    if (prefs.containsKey(key)) {
      value = jsonDecode(prefs.getString(key)!) as T;
    }
    ever(this, (value) => prefs.setString(key, jsonEncode(value)));
  }
}

class PersistentRxBool extends PersistentRx<bool> {
  PersistentRxBool(super.initial, {required super.key});
}

class PersistentRxInt extends PersistentRx<int> {
  PersistentRxInt(super.initial, {required super.key});
}

class PersistentRxDouble extends PersistentRx<double> {
  PersistentRxDouble(super.initial, {required super.key});
}

class PersistentRxString extends PersistentRx<String> {
  PersistentRxString(super.initial, {required super.key});
}

class PersistentRxColor extends Rx<Color> {
  final String key;

  PersistentRxColor(Color initial, {required this.key}) : super(initial) {
    if (prefs.containsKey(key)) {
      try {
        value = Color(prefs.getInt(key)!);
      } on Error catch (error) {
        logger.e(error, stackTrace: error.stackTrace);
        value = initial;
        prefs.remove(key);
      }
    }
    ever(this, (color) => prefs.setInt(key, color.value));
  }
}

class PersistentRxCustom<T> extends Rx<T> {
  final String key;
  final String? Function(T value) encode;
  final T Function(String value) decode;

  PersistentRxCustom(
    T initial, {
    required this.key,
    required this.encode,
    required this.decode,
  }) : super(initial) {
    if (prefs.containsKey(key)) {
      try {
        var store = prefs.getString(key);
        value = store != null ? decode(store) : initial;
      } on Error catch (error) {
        logger.e(error, stackTrace: error.stackTrace);
        value = initial;
        prefs.remove(key);
      }
    }
    ever(this, (next) {
      final data = encode(next);
      if (isNullOrEmpty(data)) {
        prefs.remove(key);
        return;
      }
      prefs.setString(key, encode(next)!);
    });
  }
}
