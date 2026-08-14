import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class RemoteFileOpener {
  final Dio _dio;

  RemoteFileOpener({Dio? dio}) : _dio = dio ?? Dio();

  Future<bool> open({required String url, required String fileName}) async {
    final cacheDirectory = await getTemporaryDirectory();
    final localPath = _localPath(
      directory: cacheDirectory,
      fileName: fileName,
      url: url,
    );

    await _dio.download(url, localPath);
    final result = await OpenFilex.open(localPath);
    return result.type == ResultType.done;
  }

  String _localPath({
    required Directory directory,
    required String fileName,
    required String url,
  }) {
    final urlName = Uri.tryParse(url)?.pathSegments.last;
    final preferredName = fileName.trim().isNotEmpty
        ? fileName.trim()
        : (urlName?.isNotEmpty == true ? urlName! : 'attachment');
    final safeName = preferredName.replaceAll(
      RegExp(r'[<>:"/\\|?*\x00-\x1F]'),
      '_',
    );
    final dotIndex = safeName.lastIndexOf('.');
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uniqueName = dotIndex > 0
        ? '${safeName.substring(0, dotIndex)}_$timestamp'
              '${safeName.substring(dotIndex)}'
        : '${safeName}_$timestamp';

    return '${directory.path}${Platform.pathSeparator}$uniqueName';
  }
}
