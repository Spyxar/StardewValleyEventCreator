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
    this.parseValue = parseValue ??
        (controls, outputMagicLetter) {
          if (controls.any((control) => control.value == null || control.value == '')) {
            return '';
          }

          List<String> values = [outputMagicLetter, ...controls.map((control) => control.value.toString())];
          return values.join(' ').trim();
        };
  }
}
