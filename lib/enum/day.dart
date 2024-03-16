import 'package:svec/enum/proper_name_enum.dart';

enum Day implements IProperNameEnum {
  sun("Sunday", "Sun"),
  mon("Monday", "Mon"),
  tue("Tuesday", "Tue"),
  wed("Wednesday", "Wed"),
  thu("Thursday", "Thu"),
  fri("Friday", "Fri"),
  sat("Saturday", "Sat");

  @override
  final String displayLabel;
  @override
  final String parseName;

  const Day(this.displayLabel, this.parseName);
}
