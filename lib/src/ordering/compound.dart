library more.ordering.compound;

import 'package:more/ordering.dart';

class CompoundOrdering<T> extends Ordering<T> {
  final List<Ordering<T>> orderings;

  const CompoundOrdering(this.orderings);

  @override
  int compare(T a, T b) {
    for (var ordering in orderings) {
      var result = ordering.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }

  @override
  Ordering<T> compound(Ordering<T> other) {
    var combined = new List<Ordering<T>>.from(orderings)..add(other);
    return new CompoundOrdering(
        new List<Ordering<T>>.from(combined, growable: false));
  }
}
