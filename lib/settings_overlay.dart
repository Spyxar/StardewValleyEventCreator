import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svec/shared_app_preferences.dart';

class SettingsOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);

  @override
  bool get opaque => false;

  @override
  String get barrierLabel => "";

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get maintainState => true;

  late final SharedPreferences _preferences;
  late final _prefsFuture = SharedPreferences.getInstance().then((value) => _preferences = value);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: FutureBuilder(
        future: _prefsFuture,
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
    'stringStronk': FormControl<String>(value: sharedPreferences.getString('stringStronk') ?? ''),
  });

  Widget _buildOverlayContent(BuildContext context) {
    // return Center(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       Column(children: [
    //
    //       ],),
    //       ElevatedButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: const Text('Save'),
    //       )
    //     ],
    //   ),
    // );
    return ReactiveForm(
      formGroup: preferencesForm,
      child: Column(
        children: <Widget>[
          ReactiveTextField(
            formControlName: 'stringStronk',
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      _onPressed(form);
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

  //Todo
  void _onPressed(FormGroup form) {
    for (String controlName in form.controls.keys) {
      sharedPreferences.setString(controlName, form.control(controlName).value);
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
