import '/imports.dart';

Widget bottomSheet(
  BuildContext context, {
  required Widget child,
}) {
  return Container(
    decoration: BoxDecoration(
      color: context.theme.colorScheme.surface,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    child: child,
  );
}
