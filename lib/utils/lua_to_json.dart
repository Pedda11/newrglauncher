import 'dart:convert';

class LuaToJson {
  static Map<String, dynamic> parseLua(String content) {
    /// Remove line breaks and leading/trailing spaces
    content = content
        .trim()
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll('\t', '');

    /// Remove the outer curly braces to get the outermost table

    var splited = content.split('=');

    content = content.replaceFirst('${splited[0]}= ', '');

    /// Replace all " = " with ":" for key-value pairs
    content = content.replaceAll(' = ', ':');

    /// Replace all lines starting with "[" with "\" for indexing
    content = content.replaceAllMapped(
        RegExp(r'\["(.*?)"\]'), (match) => '"${match.group(1)}"');

    content =
        content.replaceAllMapped(RegExp(r", -- \[\d+\]"), (match) => ': "0",');

    content = content.replaceAll(',}', '}');

    /// Parse the string into a Dart object
    Map<String, dynamic> dataStore = json.decode(content);

    return dataStore;
  }
}
