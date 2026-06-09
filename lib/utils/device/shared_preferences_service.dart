import 'package:shared_preferences/shared_preferences.dart';

class CSharedPreferencesService {
  /// -- variables --
  static const String autoSyncData = 'on';

  /// -- enable/disable data auto-synchronization --
  static Future<void> setAutoSync(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(autoSyncData, value);
  }

  /// -- check data sync status --
  static Future<bool> dataSyncIsOn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(autoSyncData) ?? false;
  }
}
