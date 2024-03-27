import 'package:svec/enum/proper_name_enum.dart';

enum Gender implements IProperNameEnum {
  male('Male', 'male'),
  female('Female', 'female');

  @override
  final String displayLabel;
  @override
  final String parseName;

  const Gender(this.displayLabel, this.parseName);
}
