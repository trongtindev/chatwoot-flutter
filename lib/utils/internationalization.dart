import '/imports.dart';

AppLocalizations get t => AppLocalizations.of(Get.context!)!;

AppLocalizations tOf(BuildContext? context) {
  return AppLocalizations.of(context ?? Get.context!)!;
}
