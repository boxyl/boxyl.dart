import 'package:boxyl/boxyl.dart' as boxyl;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

main() async {
  var path = './code';
  var code = await readLines(path);
  var interpreter = boxyl.Interpreter(code);
  interpreter.run();
}

Future<List<String>> readLines(String path) async {
  return await File(path).readAsLines();
}