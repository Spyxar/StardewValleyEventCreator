import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/page/svec_form_page.dart';
import 'package:svec/shared_app_preferences.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);

final ThemeData darkTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 102, 51, 153),
    brightness: Brightness.dark,
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedAppPreferences().init();
  runApp(const SvecApp());
}

class SvecApp extends StatefulWidget {
  const SvecApp({super.key});

  @override
  State<StatefulWidget> createState() => SvecAppState();

  static SvecAppState? of(BuildContext context) => context.findAncestorStateOfType<SvecAppState>();
}

class SvecAppState extends State<SvecApp> {
  ThemeMode _themeMode = sharedPreferences.getBool('lightMode') ?? false ? ThemeMode.light : ThemeMode.dark;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.required: (error) => 'Field can not be empty',
        ValidationMessage.number: (error) => 'Field must contain an integer',
        'doubleLimit': (error) => 'Number exceeds ${(error as Map)['maxValue']}',
        'doubleLimitNotPositive': (error) => 'Number is not positive',
      },
      child: MaterialApp(
        title: 'SVEC',
        themeMode: _themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SvecFormPage(title: 'Stardew Valley Event Creator'),
      ),
    );
  }
}
