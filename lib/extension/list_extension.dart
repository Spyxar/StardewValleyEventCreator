extension ListSeparation on List {
  List<T> separateList<T>(T separator) {
    List<T> separatedList = [];

    for (int i = 0; i < length; i++) {
      separatedList.add(this[i]);
      if (i != length - 1) {
        separatedList.add(separator);
      }
    }
    return separatedList;
  }
}
