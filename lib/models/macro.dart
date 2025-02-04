import '/imports.dart';

class MacroAction {
  final String action_name;
  final List<dynamic> action_params; // TODO: unk type

  const MacroAction({
    required this.action_name,
    required this.action_params,
  });

  factory MacroAction.fromJson(dynamic json) {
    return MacroAction(
      action_name: json['action_name'],
      action_params: json['action_params'],
    );
  }
}

class MacroInfo {
  final int id;
  final String name;
  final MacroVisibility visibility;
  final List<MacroAction> actions;
  final UserInfo created_by;
  final UserInfo updated_by;

  const MacroInfo({
    required this.id,
    required this.name,
    required this.visibility,
    required this.actions,
    required this.created_by,
    required this.updated_by,
  });

  factory MacroInfo.fromJson(dynamic json) {
    List<dynamic> actions = json['actions'];
    return MacroInfo(
      id: json['id'],
      name: json['name'],
      visibility: MacroVisibility.values.byName(json['visibility']),
      actions: actions.map(MacroAction.fromJson).toList(),
      created_by: UserInfo.fromJson(json['created_by']),
      updated_by: UserInfo.fromJson(json['updated_by']),
    );
  }
}

class ListMacrosResult {
  final List<MacroInfo> payload;
  ListMacrosResult({required this.payload});

  factory ListMacrosResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];

    return ListMacrosResult(
      payload: payload.map(MacroInfo.fromJson).toList(),
    );
  }
}
