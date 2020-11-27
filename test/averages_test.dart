import 'package:flutter_test/flutter_test.dart';
import 'package:getx_benchmark/testresult.dart';

void main() {
  test("can calc averages", () {
    final testResults = [
      TestResult(0, 1, "abc", 1),
      TestResult(0, 1, "abc", 2),
      TestResult(0, 1, "abc", 3),
      TestResult(0, 1, "cde", 1),
      TestResult(0, 1, "cde", 5),
      TestResult(0, 2, "cde", 3),
    ].calcAverages().toList();

    expect(testResults.length, 3);
    expect(testResults[0], TestResult(0, 1, "abc", 2));
    expect(testResults[1], TestResult(0, 1, "cde", 3));
    expect(testResults[2], TestResult(0, 2, "cde", 3));
  });
}
