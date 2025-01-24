import '/imports.dart';

class AgentsPickerController extends GetxController {
  final _api = Get.find<ApiService>();

  final int? initial;
  final List<int> inbox_ids;
  final items = RxList<UserInfo>();
  final radioValue = Rxn<UserInfo>();
  final checkboxValue = RxList<UserInfo>();

  AgentsPickerController({
    this.initial,
    required this.inbox_ids,
  });

  @override
  void onReady() {
    super.onReady();
    getAgents();
  }

  Future<void> getAgents() async {
    final result = await _api.listAssignableAgents(
      inbox_ids: inbox_ids,
    );
    items.value = result.getOrThrow();

    if (initial != null) {
      radioValue.value = items.value.firstWhere((e) => e.id == initial);
    }
  }

  void toggle(UserInfo info) {
    if (checkboxValue.contains(info)) {
      checkboxValue.remove(info);
      return;
    }
    checkboxValue.add(info);
  }
}

class AgentsPicker extends StatelessWidget {
  final AgentsPickerController c;

  AgentsPicker({
    super.key,
    int? initial,
    required List<int> inbox_ids,
    required int conversation_id,
  }) : c = Get.put(AgentsPickerController(
          initial: initial,
          inbox_ids: inbox_ids,
        ));

  @override
  Widget build(BuildContext context) {
    return bottomSheet(
      context,
      child: Obx(() {
        final items = c.items.value;

        return Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_outlined),
                label: Text(t.agents_search),
                hintText: t.agents_search_hint,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return buildItem(items[i]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: primaryButton(
                block: true,
                label: t.save_changes,
                onPressed: () {
                  if (c.radioValue.value != null) {
                    return Navigator.of(context).pop(c.radioValue.value!);
                  }
                  return Navigator.of(context).pop(null);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildItem(UserInfo info) {
    return Obx(() {
      final radioValue = c.radioValue.value;
      return CustomRadioListTile(
        title: Text(info.display_name),
        subtitle: Text(
          '#${info.id}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        value: info,
        groupValue: radioValue,
        onChanged: (next) => c.radioValue.value = info,
      );
    });
  }
}
