import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/checkbox.dart';

class MultiCheckboxWidget extends StatefulWidget {
  final List<CheckboxElement> values;
  final void Function(List<CheckboxElement>? value) onChanged;

  const MultiCheckboxWidget({super.key, required this.values, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _MultiCheckboxWidgetState();
}

class _MultiCheckboxWidgetState extends State<MultiCheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (CheckboxElement checkbox in widget.values)
          CheckboxListTile(
            title: Text(checkbox.label),
            controlAffinity: ListTileControlAffinity.leading,
            value: checkbox.isChecked,
            onChanged: (value) {
              setState(
                () {
                  widget.values[widget.values.indexOf(checkbox)].isChecked = value ?? false;
                  widget.onChanged(widget.values);
                },
              );
            },
          ),
      ],
    );
  }
}

class ReactiveMultiCheckbox extends ReactiveFormField<List<CheckboxElement>, List<CheckboxElement>> {
  ReactiveMultiCheckbox({super.key, super.formControlName})
      : super(builder: (ReactiveFormFieldState<List<CheckboxElement>, List<CheckboxElement>> field) {
          return MultiCheckboxWidget(values: field.value ?? [], onChanged: field.didChange);
        });

  @override
  ReactiveFormFieldState<List<CheckboxElement>, List<CheckboxElement>> createState() => ReactiveFormFieldState<List<CheckboxElement>, List<CheckboxElement>>();
}
