import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/checkbox.dart';
import 'package:svec/widget/reactive/svec_form_control.dart';
import 'package:svec/widget/svec_multi_checkbox.dart';

class SvecReactiveCheckboxGroup extends StatelessWidget {
  final String label;

  final FormGroup form;
  final String formControlName;

  const SvecReactiveCheckboxGroup({super.key, required this.label, required this.form, required this.formControlName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              children: _generateWidgetsForControlName(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateWidgetsForControlName() {
    List<Widget> widgets = [];
    AbstractControl control = form.control(formControlName);
    if (control is! SvecFormControl) {
      throw ArgumentError("Passed control was not a SvecFormControl.");
    }
    Type type = control.genericType;
    switch (type) {
      case const (bool):
        widgets.add(
          LayoutBuilder(builder: (context, constraints) {
            return ReactiveCheckboxListTile(controlAffinity: ListTileControlAffinity.leading, formControlName: formControlName);
          }),
        );
      case const (List<CheckboxElement>):
        widgets.add(
          LayoutBuilder(builder: (context, constraints) {
            return ReactiveMultiCheckbox(formControlName: formControlName);
          }),
        );
      default:
        throw UnsupportedError("Failed to create a SvecReactiveCheckboxGroup for type that is not bool or List<CheckboxElement>.");
    }
    return widgets;
  }
}
