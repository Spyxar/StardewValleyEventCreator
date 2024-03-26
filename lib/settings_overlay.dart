import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svec/main.dart';
import 'package:svec/shared_app_preferences.dart';

class SettingsOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);

  @override
  bool get opaque => false;

  @override
  String get barrierLabel => '';

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get maintainState => true;

  late final _preferencesFuture = SharedPreferences.getInstance();

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: FutureBuilder(
        future: _preferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildOverlayContent(context);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  final preferencesForm = FormGroup({
    'lightMode': FormControl<bool>(value: sharedPreferences.getBool('lightMode') ?? false),
  });

  final MaterialStateProperty<Icon?> _themeThumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.sunny);
      }
      return const Icon(Icons.nights_stay_sharp);
    },
  );

  Widget _buildOverlayContent(BuildContext context) {
    return ReactiveForm(
      formGroup: preferencesForm,
      child: Column(
        children: <Widget>[
          ReactiveSwitch(
            formControlName: 'lightMode',
            thumbIcon: _themeThumbIcon,
            onChanged: (toggle) {
              if (toggle.value ?? false) {
                SvecApp.of(context)!.changeTheme(ThemeMode.light);
              } else {
                SvecApp.of(context)!.changeTheme(ThemeMode.dark);
              }
            },
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      _savePreferences(form);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _savePreferences(FormGroup form) {
    for (String controlName in form.controls.keys) {
      switch (form.control(controlName).value.runtimeType) {
        case const (String):
          sharedPreferences.setString(controlName, form.control(controlName).value);
        case const (List<String>):
          sharedPreferences.setStringList(controlName, form.control(controlName).value);
        case const (int):
          sharedPreferences.setInt(controlName, form.control(controlName).value);
        case const (double):
          sharedPreferences.setDouble(controlName, form.control(controlName).value);
        case const (bool):
          sharedPreferences.setBool(controlName, form.control(controlName).value);
        default:
          throw UnimplementedError('Failed to save preference that is of type $runtimeType');
      }
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.7, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
