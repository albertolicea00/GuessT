import 'package:flutter/services.dart' show AssetManifest, rootBundle;

class ImageDeckEntry {
  final String answer;
  final String assetPath;

  const ImageDeckEntry({required this.answer, required this.assetPath});
}

const List<String> _imageExtensions = ['.png', '.jpg', '.jpeg', '.webp'];

/// Discovers image files dropped into [directory] at build time via
/// Flutter's asset manifest — no hand-maintained list of filenames.
/// The answer for each entry is derived from its filename.
class ImageDeckService {
  static const String directory = 'assets/images/movies/';

  static Future<List<ImageDeckEntry>> loadMoviePosters() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((path) => path.startsWith(directory))
        .where((path) => _imageExtensions.any((ext) => path.toLowerCase().endsWith(ext)));

    return paths.map((path) {
      final filename = path.substring(directory.length);
      final dot = filename.lastIndexOf('.');
      final nameOnly = dot == -1 ? filename : filename.substring(0, dot);
      final answer = nameOnly.replaceAll(RegExp(r'[_-]+'), ' ').trim();
      return ImageDeckEntry(answer: answer, assetPath: path);
    }).toList();
  }
}
