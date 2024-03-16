import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;
class SharedAppPreferences {

  Future<void> init() async {
    SharedPreferences.setPrefix('svec.');
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // String get stringStronk => sharedPreferences.getString('stringStronk') ?? '';
  //
  // set stringStronk(String value) {
  //   sharedPreferences.setString('stringStronk', value);
  // }
}

// final sharedPreferences = SharedAppPreferences();
