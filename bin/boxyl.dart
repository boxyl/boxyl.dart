import 'package:boxyl/boxyl.dart';

main(List<String> args) async {
  var path = args[0];
  var code = await readLines(path);
  var interpreter = Interpreter(code);
  interpreter.run();
}
