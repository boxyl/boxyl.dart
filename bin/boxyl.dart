import 'package:boxyl/boxyl.dart' as boxyl;
import 'dart:async';
import 'dart:io';

main(List<String> args) async {
  var path = args[0];
  var code = await readLines(path);
  var interpreter = boxyl.Interpreter(code);
  interpreter.run();
}

Future<List<String>> readLines(String path) async {
  return await File(path).readAsLines();
}