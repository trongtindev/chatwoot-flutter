import '../controllers/change_url.dart';
import '../widgets/layout.dart';
import '/imports.dart';

class ChangeUrlView extends GetView<ChangeUrlController> {
  const ChangeUrlView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = double.infinity; // TODO: responsive

    return GetBuilder(
      init: ChangeUrlController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(),
          body: buildBody(
            width: width,
            header: buildHeader(
              title: 'change_url.title'.tr,
              description: 'change_url.description'.trParams({
                'baseUrl': Uri.parse(env.API_URL).host,
              }),
            ),
            child: buildForm(width),
          ),
        );
      },
    );
  }

  Widget buildForm(double width) {
    return SizedBox(
      width: width,
      child: Obx(() {
        var isValidating = controller.isValidating.value;

        return Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !isValidating,
                controller: controller.baseUrl,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  label: Text('change_url.url'.tr),
                  hintText: 'change_url.url_hint'.tr,
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || !isUrlWithoutHttp(value)) {
                    return 'change_url.url_invalid'.tr;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              SizedBox(
                width: double.infinity,
                child: primaryButton(
                  loading: isValidating,
                  onPressed: controller.submit,
                  label: 'change_url.submit'.tr,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
