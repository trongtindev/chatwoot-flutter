import '/imports.dart';
import '../controllers/appearance.dart';

class SettingsAppearanceView extends GetView<SettingsAppearanceController> {
  const SettingsAppearanceView({super.key});

  @override
  Widget build(context) {
    return GetBuilder(
      init: SettingsAppearanceController(),
      builder: (_) {
        if (GetPlatform.isDesktop) {
          return buildBody(context);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('settings.appearance'.tr),
            centerTitle: true,
          ),
          body: buildBody(context),
        );
      },
    );
  }

  Widget buildBody(
    BuildContext context,
  ) {
    final theme = Get.find<ThemeService>();
    return ListView(
      children: [
        Obx(() {
          return ListTile(
            title: Text('settings.appearance.mode'.tr),
            subtitle:
                Text('settings.appearance.mode_${theme.mode.value.name}'.tr),
            onTap: controller.changeMode,
          );
        }),
        Obx(() {
          return SwitchListTile(
            value: theme.colours.value,
            title: Text('settings.appearance.colours'.tr),
            subtitle: Text('settings.appearance.colours_subtitle'.tr),
            onChanged: (next) => theme.colours.value = next,
          );
        }),
        Obx(() {
          var activeColor = theme.color.value;
          return Column(
            children: [
              ListTile(
                title: Text('settings.appearance.color'.tr),
                subtitle: Text(activeColor.toHexTriplet()),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(right: 16),
                  itemCount: colors.length,
                  itemBuilder: (ctx, i) {
                    var color = colors[i];
                    var selected = activeColor.compareTo(color);
                    return Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: buildColorItem(context, theme, color, selected),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget buildColorItem(
    BuildContext context,
    ThemeService theme,
    Color color,
    bool active,
  ) {
    var borderColor =
        Get.theme.brightness == Brightness.light ? Colors.grey : Colors.grey;
    var colorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: context.theme.brightness,
      contrastLevel: theme.contrast.value,
    );

    return AspectRatio(
      aspectRatio: GetPlatform.isDesktop ? 4 / 3 : 4 / 5,
      child: InkWell(
        onTap: () => theme.color.value = color,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            border: Border.all(
              width: 2,
              color: active ? color : borderColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(width: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              active
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check_circle,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
