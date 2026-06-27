import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class DiagramStorageService {
  static const String basePath = '/storage/emulated/0/Download/DiagramApp';

  Future<Directory> _ensureDir() async {
    final dir = Directory(basePath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _generateFileName(String extension) {
    return 'diagram_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }

  Future<String> saveXml(String xml) async {
    final dir = await _ensureDir();
    final file = File('${dir.path}/${_generateFileName('xml')}');
    await file.writeAsString(xml);
    return file.path;
  }

  Future<String> savePng(String data) async {
    final dir = await _ensureDir();
    final base64Str = data.contains(',') ? data.split(',').last : data;
    final Uint8List bytes = base64Decode(base64Str);
    final file = File('${dir.path}/${_generateFileName('png')}');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}