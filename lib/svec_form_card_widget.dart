import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/checkbox.dart';
import 'package:svec/svec_form_widget.dart';
import 'package:svec/widget/reactive/svec_reactive_checkbox_group.dart';
import 'package:svec/widget/svec_form_array.dart';
import 'package:svec/widget/svec_multi_input.dart';
import 'package:svec/widget/reactive/svec_reactive_array.dart';
import 'package:svec/widget/reactive/svec_reactive_multi_input.dart';
import 'package:svec/widget/reactive/svec_reactive_text_field.dart';
import 'package:svec/widget/reactive/svec_form_control.dart';

class SvecFormCardWidget extends StatefulWidget {
  final String title;

  final FormGroup form;

  const SvecFormCardWidget({super.key, required this.title, required this.form});

  @override
  State<StatefulWidget> createState() => _SvecFormCardWidgetState();
}

class _SvecFormCardWidgetState extends State<SvecFormCardWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth <= SvecFormWidget.requiredWidthForRow ? screenWidth / 1.2 : screenWidth / 3.5;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ReactiveForm(
            formGroup: widget.form,
            child: Column(
              children: [for (String key in widget.form.controls.keys) _getWidgetForFormField(key)],
            ),
          )
        ],
      ),
    );
  }

  Widget _getWidgetForFormField(String controlName) {
    AbstractControl control = widget.form.control(controlName);
    if (control is SvecFormArray) {
      return SvecReactiveArray(
        label: control.label,
        form: widget.form,
        formControlName: controlName,
      );
    } else if (control is SvecMultiInput) {
      return SvecReactiveMultiInput(
        label: control.label,
        form: widget.form,
        formControlName: controlName,
      );
    }
    if (control is! SvecFormControl) {
      throw ArgumentError('Passed control was not a SvecFormControl, SvecFormArray or SvecMultiInput.');
    }
    Type type = control.genericType;
    switch (type) {
      case const (bool):
        return ReactiveCheckboxListTile(
          formControlName: controlName,
          title: Text(control.label),
          controlAffinity: ListTileControlAffinity.leading,
        );
      case const (List<CheckboxElement>):
        return SvecReactiveCheckboxGroup(
          label: control.label,
          form: widget.form,
          formControlName: controlName,
        );
      case const (int):
      case const (double):
      case const (String):
        return SvecReactiveTextField(
          label: control.label,
          controlName: controlName,
        );
      default:
        throw UnimplementedError('Failed to create a field for type ${type.toString()}, not implemented');
    }
  }
}
