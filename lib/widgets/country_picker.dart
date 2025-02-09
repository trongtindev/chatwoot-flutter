import 'package:chatwoot/imports.dart';

class CountryPickerController extends GetxController {
  final search = TextEditingController();
  final items = countryCodes.obs;

  @override
  void onInit() {
    super.onInit();

    search.addListener(() {
      final match = countryCodes.where((e) =>
          e.name.toLowerCase().contains(search.text) ||
          e.code.toLowerCase().contains(search.text) ||
          e.dialCode.toLowerCase().contains(search.text));
      items.value = match.toList();
    });
  }
}

class CountryPicker extends StatelessWidget {
  final controller = Get.put(CountryPickerController());
  CountryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: controller.search,
            decoration: InputDecoration(
              label: Text(t.search),
              hintText: t.search_hint,
              contentPadding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = controller.items.value;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];

                  return CustomListTile(
                    title: Text(item.name),
                    subtitle: Text(item.dialCode),
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
