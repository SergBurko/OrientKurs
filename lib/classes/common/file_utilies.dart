import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class FileUtilities {
  late String _directoryName;
  late String _fileName;

  FileUtilities(fileName, directoryName) {
    _fileName = fileName;
    _directoryName = directoryName;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return '${directory.path}/$_directoryName';
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    File file = File('$path/$_fileName');

    if (!file.existsSync()) {
      file = await file.writeAsString("");
    }

    return file;
  }

  Future<String> readFromFile() async {
    try {
      final File file = (await _localFile);

      final jsonString = await file.readAsString();

      return jsonString;
    } catch (e) {
      return "Error: $e";
    }
  }

  void writeToFile(String value) async {
    final file = await _localFile;

    // Write the file

    final sink = file.openWrite(mode: FileMode.write, encoding: utf8);
    // Записываем текст в файл
     sink.write(value);
    // Закрываем файл
    await sink.flush();
    await sink.close();

    // return await file.writeAsString(value);
  }
}
