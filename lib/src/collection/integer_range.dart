library more.collection.integer_range;

import 'dart:collection' show ListBase;

import 'package:more/ordering.dart' show Ordering;
import 'package:more/src/iterable/mixins/unmodifiable.dart'
    show UnmodifiableListMixin;

/// A virtual range of integers containing an arithmetic progressions.
class IntegerRange extends ListBase<int> with UnmodifiableListMixin<int> {
  /// Creates a virtual range of numbers containing an arithmetic progressions
  /// of integer values.
  ///
  /// The constructor called without any arguments returns the empty range.
  /// For example, `new IntegerRange()` yields `<int>[]`.
  ///
  /// The constructor called with one argument returns the range of all
  /// numbers up to, but excluding the end. For example, `IntegerRange(3)`
  /// yields `<int>[0, 1, 2]`.
  ///
  /// The constructor called with two arguments returns the range between
  /// the two numbers (including the start, but excluding the end). For example,
  /// `IntegerRange(3, 6)` yields `<int>[3, 4, 5]`.
  ///
  /// The constructor called with three arguments returns the range between
  /// the first two numbers (including the start, but excluding the end) and the
  /// step value. For example, `IntegerRange(1, 7, 2)` yields `<int>[1, 3, 5]`.
  factory IntegerRange([int a, int b, int c]) {
    int start = 0;
    int stop = 0;
    int step = 1;
    if (c != null) {
      start = a;
      stop = b;
      step = c;
    } else if (b != null) {
      start = a;
      stop = b;
      step = start <= stop ? 1 : -1;
    } else if (a != null) {
      stop = a;
    }
    if (step == 0) {
      throw new ArgumentError('Non-zero step-size expected');
    } else if (start < stop && step < 0) {
      throw new ArgumentError('Positive step-size expected');
    } else if (start > stop && step > 0) {
      throw new ArgumentError('Negative step-size expected');
    }
    var span = stop - start;
    var length = span ~/ step;
    if (span % step != 0) {
      length++;
    }
    return new IntegerRange._(start, stop, step, length);
  }

  IntegerRange._(this.start, this.stop, this.step, this.length);

  /// The start of the range (inclusive).
  final int start;

  /// The stop of the range (exclusive).
  final int stop;

  /// The step size.
  final int step;

  @override
  final int length;

  @override
  Iterator<int> get iterator => new IntegerRangeIterator(start, step, length);

  @override
  int operator [](int index) {
    if (0 <= index && index < length) {
      return start + step * index;
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  @override
  bool contains(Object element) => indexOf(element) >= 0;

  @override
  int indexOf(Object element, [int startIndex = 0]) {
    if (element is int) {
      if (startIndex < 0) {
        startIndex = 0;
      }
      var ordering = step > 0
          ? new Ordering<int>.natural()
          : new Ordering<int>.natural().reversed;
      var index = ordering.binarySearch(this, element);
      if (startIndex <= index) {
        return index;
      }
    }
    return -1;
  }

  @override
  int lastIndexOf(Object element, [int stopIndex]) {
    if (element is int) {
      if (stopIndex == null || length <= stopIndex) {
        stopIndex = length - 1;
      }
      if (stopIndex < 0) {
        return -1;
      }
      var ordering = step > 0
          ? new Ordering<int>.natural()
          : new Ordering<int>.natural().reversed;
      var index = ordering.binarySearch(this, element);
      if (0 <= index && index <= stopIndex) {
        return index;
      }
    }
    return -1;
  }

  @override
  IntegerRange get reversed =>
      isEmpty ? this : new IntegerRange._(last, first - step, -step, length);

  @override
  IntegerRange sublist(int startIndex, [int stopIndex]) {
    return getRange(startIndex, stopIndex ?? length);
  }

  @override
  IntegerRange getRange(int startIndex, int stopIndex) {
    RangeError.checkValidRange(startIndex, stopIndex, length);
    return new IntegerRange._(start + startIndex * step,
        start + stopIndex * step, step, stopIndex - startIndex);
  }

  @override
  String toString() {
    if (length == 0) {
      return 'new IntegerRange()';
    } else if (start == 0 && step == 1) {
      return 'new IntegerRange($stop)';
    } else if (step == 1) {
      return 'new IntegerRange($start, $stop)';
    } else {
      return 'new IntegerRange($start, $stop, $step)';
    }
  }
}

class IntegerRangeIterator extends Iterator<int> {
  final int start;
  final int step;
  final int length;

  int index = 0;

  IntegerRangeIterator(this.start, this.step, this.length);

  @override
  int current;

  @override
  bool moveNext() {
    if (index == length) {
      current = null;
      return false;
    } else {
      current = start + step * index++;
      return true;
    }
  }
}
