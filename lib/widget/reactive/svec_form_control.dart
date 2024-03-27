import 'package:reactive_forms/reactive_forms.dart';

class SvecFormControl<T> extends FormControl<T> {
  late String label = 'Missing Label';

  final String outputMagicLetter;

  Type get genericType => T;

  late String Function(Object value, String magicLetter)? parseValue;

  SvecFormControl({
    super.value,
    super.validators,
    super.asyncValidators,
    super.asyncValidatorsDebounceTime,
    super.touched,
    super.disabled,
    required this.outputMagicLetter,
    String Function(Object value, String magicLetter)? parseValue,
  }) {
    this.parseValue = parseValue ?? (value, outputMagicLetter) => '$outputMagicLetter ${value.toString()}';
  }

  SvecFormControl.labeled({
    super.value,
    super.validators,
    super.asyncValidators,
    super.asyncValidatorsDebounceTime,
    super.touched,
    super.disabled,
    required this.outputMagicLetter,
    required this.label,
    String Function(Object value, String magicLetter)? parseValue,
  }) {
    this.parseValue = parseValue ?? (value, outputMagicLetter) => '$outputMagicLetter ${value.toString()}';
  }
}
