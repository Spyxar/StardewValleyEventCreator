import 'package:reactive_forms/reactive_forms.dart';

class SvecMultiInput<T> extends FormArray<T> {
  final String label;

  final String outputMagicLetter;

  Type get genericType => T;

  late String Function(Object value, String magicLetter)? parseValue;

  SvecMultiInput(
    super.controls, {
    super.validators,
    super.asyncValidators,
    super.asyncValidatorsDebounceTime,
    super.disabled,
    required this.label,
    required this.outputMagicLetter,
    String Function(Object value, String magicLetter)? parseValue,
  }) {
    this.parseValue = parseValue ?? (value, outputMagicLetter) => "$outputMagicLetter ${value.toString()}";
  }
}
