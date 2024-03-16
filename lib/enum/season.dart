import 'package:svec/enum/proper_name_enum.dart';

enum Season implements IProperNameEnum {
  spring("Spring", "spring"),
  summer("Summer", "summer"),
  fall("Fall", "fall"),
  winter("Winter", "winter");

  @override
  final String displayLabel;
  @override
  final String parseName;

  const Season(this.displayLabel, this.parseName);
}
