import 'package:dio/dio.dart';

class HlsUrlHelper {
  static String buildMasterUrl(String mp4Url) {
    final uri = Uri.parse(mp4Url);
    final segments = List<String>.from(uri.pathSegments);

    final lessonsIndex = segments.indexOf('lessons');
    if (lessonsIndex == -1 || segments.length <= lessonsIndex + 1) {
      return mp4Url;
    }

    final fileName = segments[lessonsIndex + 1];
    final dotIndex = fileName.lastIndexOf('.');
    final baseName =
        dotIndex == -1 ? fileName : fileName.substring(0, dotIndex);

    final newSegments = [
      ...segments.sublist(0, lessonsIndex),
      'hls',
      'lessons',
      baseName,
      'master.m3u8',
    ];

    return uri.replace(pathSegments: newSegments).toString();
  }

  static Future<Map<String, String>> fetchQualities({
    required String mp4Url,
    required Dio dio,
  }) async {
    final masterUrl = buildMasterUrl(mp4Url);
    final qualities = <String, String>{};

    try {
      final response = await dio.get<String>(
        masterUrl,
        options: Options(responseType: ResponseType.plain),
      );

      final content = response.data;
      if (content == null || !content.contains('#EXTM3U')) {
        return qualities;
      }

      qualities['auto'] = masterUrl;

      final baseUri = Uri.parse(masterUrl);

      final lines = content
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];

        if (!line.startsWith('#EXT-X-STREAM-INF')) continue;
        if (i + 1 >= lines.length) continue;

        final variantPath = lines[i + 1];
        if (variantPath.startsWith('#')) continue;

        final resolvedUri = baseUri.resolve(variantPath);

        final heightMatch = RegExp(r'RESOLUTION=\d+x(\d+)').firstMatch(line);
        final label = heightMatch != null
            ? heightMatch.group(1)!
            : 'variant_$i';

        qualities[label] = resolvedUri.toString();
      }
    } catch (_) {
      return qualities;
    }

    return qualities;
  }
}