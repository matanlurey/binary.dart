#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:path/path.dart' as p;

void main() {
  // Check if the current working directory is the root of the project.
  if (!io.File('pubspec.yaml').existsSync()) {
    io.stderr.writeln('This script must be run from the root of the project.');
    io.exitCode = 1;
    return;
  }

  // Load 'tool/template.tpl'.
  final template = io.File(p.join('tool', 'template.tpl')).readAsStringSync();

  // Generate files based on the following descriptors:
  ({
    p.join('lib', 'src', 'uint8.dart'): {
      'NAME': 'Uint8',
      'DESCRIPTION': 'unsigned 8-bit integer',
      'WIDTH': '8',
      'MIN': '0',
      'MAX': '255',
    },
    p.join('lib', 'src', 'uint16.dart'): {
      'NAME': 'Uint16',
      'DESCRIPTION': 'unsigned 16-bit integer',
      'WIDTH': '16',
      'MIN': '0',
      'MAX': '65535',
    },
    p.join('lib', 'src', 'uint32.dart'): {
      'NAME': 'Uint32',
      'DESCRIPTION': 'unsigned 32-bit integer',
      'WIDTH': '32',
      'MIN': '0',
      'MAX': '4294967295',
    },
    p.join('lib', 'src', 'int8.dart'): {
      'NAME': 'Int8',
      'DESCRIPTION': 'signed 8-bit integer',
      'WIDTH': '8',
      'MIN': '-128',
      'MAX': '127',
    },
    p.join('lib', 'src', 'int16.dart'): {
      'NAME': 'Int16',
      'DESCRIPTION': 'signed 16-bit integer',
      'WIDTH': '16',
      'MIN': '-32768',
      'MAX': '32767',
    },
    p.join('lib', 'src', 'int32.dart'): {
      'NAME': 'Int32',
      'DESCRIPTION': 'signed 32-bit integer',
      'WIDTH': '32',
      'MIN': '-2147483648',
      'MAX': '2147483647',
    },
  }).forEach((path, data) {
    io.stderr.writeln('Generating $path...');
    var output = template;
    data.forEach((key, value) {
      output = output.replaceAll('{{$key}}', value);
    });
    io.File(path).writeAsStringSync(output);
  });

  io.stderr.writeln('Done!');
}
