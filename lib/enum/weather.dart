import 'package:svec/enum/proper_name_enum.dart';

enum Weather implements IProperNameEnum {
  sunny('Sunny', 'sunny'),
  rainy('Rainy', 'rainy');

  @override
  final String displayLabel;
  @override
  final String parseName;

  const Weather(this.displayLabel, this.parseName);
}
