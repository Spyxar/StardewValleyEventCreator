import 'package:reactive_forms/reactive_forms.dart';

class SvecMultiInput<T> extends FormArray<T> {
  final String label;

  final String outputMagicLetter;

  Type get genericType => T;

  late String Function(List<AbstractControl<dynamic>> controls, String magicLetter)? parseValue;

  SvecMultiInput(
    super.controls, {
    super.validators,
    super.asyncValidators,
    super.asyncValidatorsDebounceTime,
    super.disabled,
    required this.label,
    required this.outputMagicLetter,
    String Function(List<AbstractControl<dynamic>> controls, String magicLetter)? parseValue,
  }) {
    List<String> values = [];
    for (AbstractControl<dynamic> control in controls) {
      values.add(control.value.toString());
    }
    this.parseValue = parseValue ?? (controls, outputMagicLetter) => "$outputMagicLetter ${values.join(" ")}";
  }
}
