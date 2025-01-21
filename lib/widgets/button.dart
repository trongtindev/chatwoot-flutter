import '/imports.dart';

Widget primaryButton({
  required String label,
  bool? loading,
  required void Function()? onPressed,
  bool? block,
}) {
  block ??= false;
  loading ??= false;

  return SizedBox(
    width: block ? double.infinity : null,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(label),
    ),
  );
}

Widget warningButton({
  required String label,
  bool? loading,
  required void Function()? onPressed,
  bool? block,
  Icon? prependIcon,
  Icon? appendIcon,
}) {
  block ??= false;
  loading ??= false;

  return SizedBox(
    width: block ? double.infinity : null,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prependIcon != null) prependIcon,
                Text(label),
                if (appendIcon != null) appendIcon,
              ],
            ),
    ),
  );
}

Widget defaultButton({
  required String label,
  bool? loading,
  required void Function()? onPressed,
  bool? block,
}) {
  block ??= false;
  loading ??= false;

  return SizedBox(
    width: block ? double.infinity : null,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(label),
    ),
  );
}
