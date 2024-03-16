import 'package:svec/enum/proper_name_enum.dart';

enum Pet implements IProperNameEnum {
  cat("Cat", "cat"),
  dog("Dog", "dog");

  @override
  final String displayLabel;
  @override
  final String parseName;

  const Pet(this.displayLabel, this.parseName);
}
