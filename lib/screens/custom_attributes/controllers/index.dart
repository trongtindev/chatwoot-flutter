import '/imports.dart';

class CustomAttributesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  CustomAttributesController() {
    tabController = TabController(length: 2, vsync: this);
  }
}
