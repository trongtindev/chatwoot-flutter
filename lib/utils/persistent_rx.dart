import '/imports.dart';

class PersistentRx<T> extends Rx<T> {
  final String key;

  PersistentRx(T initial, {required this.key}) : super(initial) {
    var storage = GetStorage();
    if (storage.hasData(key)) {
      value = storage.read<T>(key) ?? initial;
    }
    ever(this, (value) => storage.write(key, value));
  }
}

class PersistentRxn<T> extends Rxn<T> {
  final String key;

  PersistentRxn({required this.key, T? initial}) : super(initial) {
    var storage = GetStorage();
    if (storage.hasData(key)) {
      value = storage.read<T>(key) ?? initial;
    }
    ever(this, (value) => storage.write(key, value));
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
    var storage = GetStorage();
    if (storage.hasData(key)) {
      try {
        value = Color(storage.read<int>(key) ?? 0);
      } catch (error) {
        print(error);
        value = initial;
        storage.remove(key);
      }
    }
    ever(this, (color) => storage.write(key, color.value));
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
    var storage = GetStorage();
    if (storage.hasData(key)) {
      try {
        var store = storage.read<String>(key);
        value = store != null ? decode(store) : initial;
      } catch (error) {
        print(error);
        value = initial;
        storage.remove(key);
      }
    }
    ever(this, (next) => storage.write(key, encode(next)));
  }
}
