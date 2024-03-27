import 'package:reactive_forms/reactive_forms.dart';

class DoubleLimitValidator extends Validator {
  final double maxValue;
  final bool positiveOnly;

  const DoubleLimitValidator(this.maxValue, {this.positiveOnly = false});

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    if (control.value == null){
      return null;
    }
    if (control.value is! double || control.value > maxValue) {
      return <String, dynamic>{
        'doubleLimit': <String, dynamic>{
          'maxValue': maxValue,
        },
      };
    }

    if (positiveOnly && control.value < 0) {
      return <String, dynamic>{
        'doubleLimitNotPositive': true,
      };
    }

    return null;
  }
}
