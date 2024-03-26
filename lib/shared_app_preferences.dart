import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;

class SharedAppPreferences {
  Future<void> init() async {
    SharedPreferences.setPrefix('svec.');
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
