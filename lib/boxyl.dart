import 'dart:io';

const reset = '\x1B[0m';
const bold = '\x1B[1m';
const italic = '\x1B[3m';
const red = '\x1B[31m';
const green = '\x1B[32m';
const blue = '\x1B[34m';

Future<List<String>> readLines(String path) async {
  return await File(path).readAsLines();
}

class Interpreter {
  var index = 0;
  List<String> lines;
  var memory = {};
  dynamic temp;

  Interpreter(this.lines);

  panic(String message, [String help = 'subscribe to https://youtube.com/@pihedron']) {
    throw '$red$bold[ERROR]\n$message\n\n\t$blue${index + 1}$reset: ${lines[index]}\n\n$green$bold[HELP]\n$help\n\n$red[TRACE]';
  }

  num sum(List<num> nums) {
    num n = 0;
    for (var num in nums) {
      n += num;
    }
    return n;
  }

  num mul(List<num> nums) {
    num n = 1;
    for (var num in nums) {
      n *= num;
    }
    return n;
  }

  num bit(bool boolean) {
    return boolean ? 1 : 0;
  }

  num eql(List items) {
    return bit(items.every((item) => item == items[0]));
  }

  run() {
    var quoted = false;
    while (index < lines.length) {
      var line = lines[index];
      var tokens = line.split(' ');
      var command = tokens[0];
      var args = tokens.sublist(1);

      if (quoted) {
        if (line == '"') {
          quoted ^= true;
          temp = temp.substring(1);
        } else {
          temp += '\n$line';
        }
        index++;
        continue;
      }

      switch (command) {
        case 'set':
          if (args.isEmpty || args.length > 2) {
            panic('expected 1 to 2 arguments');
          }
          var name = args[0];
          if (args.length == 1) {
            if (temp == null) {
              panic('missing value for assignment', 'try "set variable:name value:name/literal?"\n"set a 0" sets value of "a" to 0\n"set a b" copies value of "b" to "a"\n"set a" copies value from temporary memory to "a"');
            } else {
              memory[name] = temp;
            }
          } else {
            var value = num.parse(args[1]);
            memory[name] = value;
          }
          break;
        case 'ray':
          temp = [];
          for (var arg in args) {
            var element = memory[arg];
            temp.add(element);
          }
          break;
        case 'mul':
          if (args.isEmpty) {
            if (temp == null) {
              panic('expected ray for multiplication');
            }
            var nums = (temp as List).cast<num>();
            temp = mul(nums);
          } else {
            var nums = (memory[args[0]] as List).cast<num>();
            temp = mul(nums);
          }
          break;
        case 'sum':
          if (args.isEmpty) {
            if (temp == null) {
              panic('expected ray for summation');
            }
            var nums = (temp as List).cast<num>();
            temp = sum(nums);
          } else {
            var nums = (memory[args[0]] as List).cast<num>();
            temp = sum(nums);
          }
          break;
        case 'out':
          if (args.isEmpty) {
            stdout.write(temp);
          } else {
            var name = args[0];
            stdout.write(memory[name]);
          }
        case 'loc':
          memory[args[0]] = index;
          break;
        case 'hop':
          if (args.isEmpty || args.length > 2) {
            panic('expected 1 to 2 arguments', 'try "hop location:name condition:name?"\nvalue of location will be treated as the line number to hop to');
          }
          var loc = args[0];
          if (args.length == 1) {
            if (temp == null) {
              panic('missing bit value for comparison', 'condition bit is a number where zero is false and non-zero is true');
            } else {
              if (temp != 0) {
                index = memory[loc] - 1;
              }
            }
          } else {
            var name = args[1];
            if (memory[name] != 0) {
              index = memory[loc] - 1;
            }
          }
          break;
        case 'eql':
          if (args.isEmpty) {
            if (temp == null) {
              panic('expected ray to compare');
            }
            var nums = temp as List;
            temp = eql(nums);
          } else {
            var nums = memory[args[0]] as List;
            temp = eql(nums);
          }
          break;
        case 'not':
          temp = 1 - temp;
          break;
        case 'del':
          temp = null;
        case '"':
          temp ??= '';
          quoted ^= true;
          break;
        default:
      }
      index++;
    }
  }
}
