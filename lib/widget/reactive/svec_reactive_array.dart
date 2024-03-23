import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/widget/svec_form_array.dart';

//ToDo: Replace 'Add'-button with 'ghostrows' - auto-create new row when typing in last one
class SvecReactiveArray extends StatelessWidget {
  final String label;

  final FormGroup form;
  final String formControlName;

  const SvecReactiveArray({super.key, required this.label, required this.form, required this.formControlName});

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
    if (control is! SvecFormArray) {
      throw ArgumentError("Passed control was not a SvecFormArray.");
    }
    Type type = control.genericType;
    switch (type) {
      case const (String):
        widgets.add(
          ReactiveFormArray(
            formArrayName: formControlName,
            builder: (context, formArray, child) {
              List<Widget> fields = [];
              for (AbstractControl abstractControl in control.controls) {
                fields.add(
                  ReactiveTextField(
                    formControl: abstractControl as FormControl,
                  ),
                );
              }
              return Column(
                children: [
                  ...fields,
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      control.add(
                        FormControl<String>(),
                      );
                    },
                    child: const Text("Add"),
                  )
                ],
              );
            },
          ),
        );
      default:
        throw UnsupportedError("Failed to create a SvecReactiveArray for type that is not String.");
    }
    return widgets;
  }
}
