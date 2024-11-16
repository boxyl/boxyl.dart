import 'dart:io';

class Interpreter {
  var index = 0;
  List<String> lines;
  var memory = {};
  dynamic temp;

  Interpreter(this.lines);

  int sum(List<int> nums) {
    int n = 0;
    for (var num in nums) {
      n += num;
    }
    return n;
  }

  int mul(List<int> nums) {
    int n = 1;
    for (var num in nums) {
      n *= num;
    }
    return n;
  }

  int bit(bool boolean) {
    return boolean ? 1 : 0;
  }

  int eql(List items) {
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
            throw Exception('expected 1 to 2 arguments');
          }
          var name = args[0];
          if (args.length == 1) {
            if (temp == null) {
              throw Exception('expected value to set');
            } else {
              memory[name] = temp;
            }
          } else {
            var value = int.parse(args[1]);
            memory[name] = value;
          }
          break;
        case 'ray':
          if (args.isEmpty) {
            throw Exception('expected ray elements');
          }
          temp = [];
          for (var arg in args) {
            var element = memory[arg];
            temp.add(element);
          }
          break;
        case 'mul':
          if (args.isEmpty) {
            if (temp == null) {
              throw Exception('expected ray to multiply\n\n\t${index + 1}: $line\n\nTrace:');
            }
            var nums = (temp as List).cast<int>();
            temp = mul(nums);
          } else {
            var nums = (memory[args[0]] as List).cast<int>();
            temp = mul(nums);
          }
          break;
        case 'sum':
          if (args.isEmpty) {
            if (temp == null) {
              throw Exception('expected ray to sum');
            }
            var nums = (temp as List).cast<int>();
            temp = sum(nums);
          } else {
            var nums = (memory[args[0]] as List).cast<int>();
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
            throw Exception('expected 1 to 2 arguments');
          }
          var loc = args[0];
          if (args.length == 1) {
            if (temp == null) {
              throw Exception('expected bit value to compare');
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
              throw Exception('expected ray to compare\n\n\t${index + 1}: $line\n\nTrace:');
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
