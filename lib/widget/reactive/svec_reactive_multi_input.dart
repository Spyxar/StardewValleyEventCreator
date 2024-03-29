import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/extension/list_extension.dart';
import 'package:svec/widget/reactive/svec_form_control.dart';
import 'package:svec/widget/svec_multi_input.dart';

class SvecReactiveMultiInput extends StatelessWidget {
  final String label;

  final FormGroup form;
  final String formControlName;

  const SvecReactiveMultiInput({super.key, required this.label, required this.form, required this.formControlName});

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
    if (control is! SvecMultiInput) {
      throw ArgumentError('Passed control was not a SvecMultiInput.');
    }
    widgets.add(
      ReactiveFormArray(
        formArrayName: formControlName,
        builder: (context, formArray, child) {
          List<Widget> fields = [];
          for (AbstractControl abstractControl in control.controls) {
            fields.add(
              Expanded(
                child: _getWidgetForControl(abstractControl),
              ),
            );
          }

          return Row(
            children: [
              ...fields.separateList(const SizedBox(width: 7)),
            ],
          );
        },
      ),
    );
    return widgets;
  }

  Widget _getWidgetForControl(AbstractControl control) {
    if (control is! SvecFormControl) {
      throw UnsupportedError('Failed to create a SvecReactiveMultiInput for control that is not SvecFormControl.');
    }
    Type type = control.genericType;
    switch (type) {
      case const (String):
        return ReactiveTextField(
          formControl: control as FormControl,
        );
      case const (bool):
        return ReactiveCheckbox(
          formControl: control as FormControl<bool>,
        );
      default:
        throw UnsupportedError('Failed to create a SvecReactiveMultiInput for type $type.');
    }
  }
}
