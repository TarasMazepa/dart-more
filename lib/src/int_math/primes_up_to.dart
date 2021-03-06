library more.int_math.primes_up_to;

import 'package:more/src/collection/bitlist.dart';

/// Returns primes up to a [limit] computed by the Sieve of Eratosthenes.
List<int> primesUpTo(int limit) {
  var sieve = new BitList(limit + 1);
  for (var i = 2; i * i <= limit; i++) {
    if (!sieve[i]) {
      for (var j = i * i; j <= limit; j += i) {
        sieve[j] = true;
      }
    }
  }
  var primes = <int>[];
  for (var i = 2; i <= limit; i++) {
    if (!sieve[i]) {
      primes.add(i);
    }
  }
  return primes;
}
