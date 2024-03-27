import 'package:reactive_forms/reactive_forms.dart';

class Parsers {
  static String booleanParser(Object value, String outputMagicLetter) {
    return value == true ? outputMagicLetter : '';
  }

  static String invertedBooleanParser(Object value, String outputMagicLetter) {
    return value != true ? outputMagicLetter : '';
  }

  static String multiInputIntegerNoneNullParser(List<AbstractControl<dynamic>> controls, String outputMagicLetter) {
    List<String> output = [outputMagicLetter];

    for (AbstractControl control in controls) {
      if (control.value == null || int.tryParse(control.value) == null) {
        return '';
      }
      output.add(control.value);
    }

    return output.join(' ');
  }
}
