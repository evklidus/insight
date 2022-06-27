import 'dart:io';

String findJson(String name) => File('test/utilities/jsons/$name.json').readAsStringSync();
