import '/screens/contacts/controllers/detail.dart';
import '/imports.dart';

class ContactDetailView extends StatelessWidget {
  final ContactDetailController controller;
  final int contact_id;

  ContactDetailView({
    super.key,
    required this.contact_id,
    ContactInfo? initial,
  }) : controller = Get.isRegistered<ContactDetailController>(
          tag: contact_id.toString(),
        )
            ? Get.find<ContactDetailController>(tag: contact_id.toString())
            : Get.put(
                ContactDetailController(
                  contact_id: contact_id,
                  initial: initial,
                ),
                tag: contact_id.toString(),
              );

  @override
  Widget build(BuildContext context) {
    // final realtime = Get.find<RealtimeService>();

    return Obx(() {
      var info = controller.info.value;

      return Scaffold(
        appBar: AppBar(
          title: info != null ? Text(info.name) : null,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {},
            ),
            Padding(padding: EdgeInsets.only(right: 8)),
          ],
        ),
        body: Builder(
          builder: (_) {
            if (info == null) return Center(child: CircularProgressIndicator());

            return ListView(
              padding: EdgeInsets.all(8),
              children: [
                buildCommonAttributes(info),
                Padding(padding: EdgeInsets.only(top: 8)),
                buildAdditionalAttributes(info.additional_attributes),
                Padding(padding: EdgeInsets.only(top: 8)),
                buildCustomAttributes(info.custom_attributes),
              ],
            );
          },
        ),
      );
    });
  }

  Widget buildCommonAttributes(ContactInfo info) {
    return Card(
      child: Column(
        children: [
          buildAttribute(
            label: 'contact.id',
            value: info.id.toString(),
            iconData: Icons.numbers_outlined,
          ),
          if (info.phone_number != null)
            buildAttribute(
              label: 'contact.phone',
              value: info.phone_number!,
              iconData: Icons.phone_outlined,
            ),
          if (info.email != null)
            buildAttribute(
              label: 'contact.email',
              value: info.email!,
              iconData: Icons.email_outlined,
            ),
          if (info.identifier != null)
            buildAttribute(
              label: 'contact.identifier',
              value: info.identifier!,
              iconData: Icons.key_outlined,
            ),
          buildAttribute(
            label: 'contact.last_activity_at',
            value: formatTimeago(info.last_activity_at),
            iconData: Icons.visibility_outlined,
          ),
          buildAttribute(
            label: 'contact.created_at',
            value: formatTimeago(info.created_at),
            iconData: Icons.more_time_outlined,
          ),
        ],
      ),
    );
  }

  Widget buildAdditionalAttributes(
      ContactAdditionalAttributes additional_attributes) {
    var unavailableText = 'common.unavailable'.tr;
    return Card(
      child: Column(
        children: [
          buildAttribute(
            label: 'contact.attributes.city',
            value: additional_attributes.city ?? unavailableText,
            iconData: Icons.my_location_outlined,
          ),
          buildAttribute(
            label: 'contact.attributes.country',
            value: additional_attributes.country ?? unavailableText,
            iconData: Icons.phone_outlined,
          ),
          buildAttribute(
            label: 'contact.attributes.company_name',
            value: additional_attributes.company_name ?? unavailableText,
            iconData: Icons.work_outline,
          ),
          buildAttribute(
            label: 'contact.attributes.country_code',
            value: additional_attributes.country_code ?? unavailableText,
            iconData: Icons.my_location_outlined,
          ),
        ],
      ),
    );
  }

  Widget buildCustomAttributes(Map<String, dynamic> custom_attributes) {
    var items = custom_attributes.entries.toList();
    return Card(
      child: Obx(() {
        var customAttributes = controller.customAttributes.value;

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (_, i) {
            var item = items[i];
            var label = customAttributes
                .firstWhereOrNull((e) => e.attribute_key == item.key);
            return buildAttribute(
              label: label != null ? label.attribute_display_name : item.key,
              value: item.value,
            );
          },
        );
      }),
    );
  }

  Widget buildAttribute({
    required String label,
    required String value,
    IconData? iconData,
  }) {
    return ListTile(
      leading: iconData != null ? Icon(iconData) : null,
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
