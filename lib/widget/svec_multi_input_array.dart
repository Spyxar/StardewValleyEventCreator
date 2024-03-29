import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/widget/svec_multi_input.dart';

class SvecMultiInputArray<T> extends FormArray<T> {
  final String label;

  final String outputMagicLetter;

  Type get genericType => T;

  late String Function(List<SvecMultiInput<dynamic>> controls, String magicLetter)? parseValue;

  List<SvecMultiInput<T>> multiInputControls;

  SvecMultiInputArray({
    super.validators,
    super.asyncValidators,
    super.asyncValidatorsDebounceTime,
    super.disabled,
    required this.label,
    required this.outputMagicLetter,
    required this.multiInputControls,
    String Function(List<SvecMultiInput<dynamic>> controls, String magicLetter)? parseValue,
  }) : super([]) {
    this.parseValue = parseValue ??
        (controls, outputMagicLetter) {
          List<String> values = [];

          controlLoop:
          for (SvecMultiInput input in controls) {
            if (input.value is List) {
              for (var value in input.value as List) {
                if (value == null || value == '') {
                  continue controlLoop;
                }
              }
              values.add('$outputMagicLetter ${input.value!.join(" ")}');
            }
          }

          return values.join('/').trim();
        };
  }
}
