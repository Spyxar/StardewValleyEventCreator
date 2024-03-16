class Parsers {
  static String booleanParser(Object value, String outputMagicLetter) {
    return value == true ? outputMagicLetter : '';
  }

  static String invertedBooleanParser(Object value, String outputMagicLetter) {
    return value != true ? outputMagicLetter : '';
  }
}
