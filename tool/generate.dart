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
      'CONSTRUCTOR': 'unsigned',
      'DESCRIPTION': 'unsigned 8-bit integer',
      'WIDTH': '8',
      'MIN': '0',
      'MAX': '255',
    },
    p.join('lib', 'src', 'uint16.dart'): {
      'NAME': 'Uint16',
      'CONSTRUCTOR': 'unsigned',
      'DESCRIPTION': 'unsigned 16-bit integer',
      'WIDTH': '16',
      'MIN': '0',
      'MAX': '65535',
      'IGNORE_COVERAGE': 'true',
    },
    p.join('lib', 'src', 'uint32.dart'): {
      'NAME': 'Uint32',
      'CONSTRUCTOR': 'unsigned',
      'DESCRIPTION': 'unsigned 32-bit integer',
      'WIDTH': '32',
      'MIN': '0',
      'MAX': '4294967295',
      'IGNORE_COVERAGE': 'true',
    },
    p.join('lib', 'src', 'int8.dart'): {
      'NAME': 'Int8',
      'CONSTRUCTOR': 'signed',
      'DESCRIPTION': 'signed 8-bit integer',
      'WIDTH': '8',
      'MIN': '-128',
      'MAX': '127',
    },
    p.join('lib', 'src', 'int16.dart'): {
      'NAME': 'Int16',
      'CONSTRUCTOR': 'signed',
      'DESCRIPTION': 'signed 16-bit integer',
      'WIDTH': '16',
      'MIN': '-32768',
      'MAX': '32767',
      'IGNORE_COVERAGE': 'true',
    },
    p.join('lib', 'src', 'int32.dart'): {
      'NAME': 'Int32',
      'CONSTRUCTOR': 'signed',
      'DESCRIPTION': 'signed 32-bit integer',
      'WIDTH': '32',
      'MIN': '-2147483648',
      'MAX': '2147483647',
      'IGNORE_COVERAGE': 'true',
    },
  }).forEach((path, data) {
    io.stderr.writeln('Generating $path...');
    var output = template;
    data.forEach((key, value) {
      output = output.replaceAll('{{$key}}', value);
    });

    // If the 'CONSTRUCTOR' key is not 'signed', remove region blocks
    // that are specific to signed integers - from {{#SIGNED}} to {{/SIGNED}}.
    if (data['CONSTRUCTOR'] != 'signed') {
      output = output.replaceAll(
        RegExp(
          '{{#SIGNED}}.*?{{/SIGNED}}',
          dotAll: true,
          multiLine: true,
        ),
        '',
      );

      // Just remove each line that contains the above region blocks.
      output = output.split('\n').where((line) {
        return !line.contains('{{#UNSIGNED}}') &&
            !line.contains('{{/UNSIGNED}}');
      }).join('\n');
    } else {
      output = output.replaceAll(
        RegExp(
          '{{#UNSIGNED}}.*?{{/UNSIGNED}}',
          dotAll: true,
          multiLine: true,
        ),
        '',
      );

      // Just remove each line that contains the above region blocks.
      output = output.split('\n').where((line) {
        return !line.contains('{{#SIGNED}}') && !line.contains('{{/SIGNED}}');
      }).join('\n');
    }

    if (data['IGNORE_COVERAGE'] == 'true') {
      output = '// coverage:ignore-file\n\n$output';
    }

    io.File(path).writeAsStringSync(output);
  });

  // Run dartfmt on the generated files.
  io.stderr.writeln('Running dartfmt...');
  final result = io.Process.runSync('dart', [
    'format',
    'lib/src',
  ]);
  if (result.exitCode != 0) {
    io.stderr.writeln(result.stderr);
    io.exitCode = 1;
    return;
  }

  io.stderr.writeln('Done!');
}
