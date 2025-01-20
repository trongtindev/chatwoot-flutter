import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/imports.dart';

AppLocalizations get t => AppLocalizations.of(Get.context!)!;

AppLocalizations tOf(BuildContext? context) {
  return AppLocalizations.of(context ?? Get.context!)!;
}
