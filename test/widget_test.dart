// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:cs_467_arcore/main.dart';
// import 

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
}