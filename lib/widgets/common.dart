import '../imports.dart';

// TODO: make better UI
Widget error(
  BuildContext context, {
  required String message,
  void Function()? onRetry,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Card(
        color: context.theme.colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.theme.colorScheme.onError,
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  t.error,
                  style: TextStyle(
                    fontSize: Get.textTheme.titleLarge!.fontSize,
                    color: context.theme.colorScheme.onError,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: Get.textTheme.bodyMedium!.fontSize,
                    color: context.theme.colorScheme.onError,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (onRetry != null)
        defaultButton(
          label: t.retry,
          onPressed: onRetry,
        ),
    ],
  );
}

// TODO: make better UI
Widget loadMore() {
  return Column(
    children: [
      Divider(),
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ],
  );
}

// TODO: make better UI
Widget noMore() {
  return Column(
    children: [
      Divider(),
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
        child: Text(
          t.no_more,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

// TODO: make better UI
Widget buildLabel(String label) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(label),
  );
}

// TODO: make better UI
Widget emptyState(
  BuildContext context, {
  String? image,
  required String title,
  required String description,
  List<Widget>? actions,
}) {
  actions ??= [];

  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Image.asset(
              'assets/images/empty/$image',
              width: min(context.width * 0.5, 256),
            ),
          Text(
            title,
            style: TextStyle(
              fontSize: context.textTheme.titleLarge!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: context.textTheme.bodyMedium!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget errorState(
  BuildContext context, {
  String? title,
  required String error,
  StackTrace? stackTrace,
  Function()? onRetry,
}) {
  return emptyState(
    context,
    image: 'error.png',
    title: t.error,
    description: error.toString(),
  );
}

class CustomListTile extends ListTile {
  const CustomListTile({
    super.key,
    super.title,
    super.subtitle,
    super.isThreeLine,
    super.leading,
    super.tileColor,
    super.onTap,
    super.trailing,
  }) : super(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
        );
}

class CustomRadioListTile<T> extends ListTile {
  final T value;
  final T groupValue;
  final bool selected;
  final Function(T next) onChanged;

  const CustomRadioListTile({
    super.key,
    super.title,
    super.subtitle,
    super.isThreeLine,
    super.leading,
    super.tileColor,
    super.onTap,
    required this.value,
    required this.groupValue,
    required this.selected,
    required this.onChanged,
  }) : super(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
        );

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: super.leading,
      title: super.title,
      subtitle: super.subtitle,
      trailing: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: (_) => onChanged(value),
      ),
      onTap: () => onChanged(value),
    );
  }
}
