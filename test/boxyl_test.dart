import 'package:boxyl/boxyl.dart';
import 'package:test/test.dart';

void main() {
  test('factorial', () async {
    var path = './test/factorial.boxyl';
    var code = await readLines(path);
    var interpreter = Interpreter(code);
    interpreter.run();
    expect(interpreter.memory['x'], 3628800);
  });
}
