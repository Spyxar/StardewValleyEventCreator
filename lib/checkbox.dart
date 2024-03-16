import 'package:svec/enum/proper_name_enum.dart';

class CheckboxElement {
  String label;
  String parseName;
  bool isChecked = false;

  CheckboxElement(this.label, this.parseName, this.isChecked);

  static List<CheckboxElement> createListFromEnum<T extends IProperNameEnum>(List<T> enumValues, bool defaultValue) {
    List<CheckboxElement> elements = [];
    for (var value in enumValues) {
      elements.add(CheckboxElement(value.displayLabel, value.parseName, defaultValue));
    }
    return elements;
  }

  @override
  String toString() {
    return isChecked.toString();
  }
}
