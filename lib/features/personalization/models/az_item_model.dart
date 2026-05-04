import 'package:azlistview/azlistview.dart';

class CAzItemModel extends ISuspensionBean {
  final String tag, title;

  CAzItemModel({
    required this.tag,
    required this.title,
  });

  @override
  String getSuspensionTag() {
    return tag;
  }
}
