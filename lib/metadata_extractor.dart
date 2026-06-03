/// A comprehensive metadata extraction package for Flutter.
///
/// This library provides implementations for parsing rich metadata from
/// media files, specifically offering specialized extractors for both images
/// (including EXIF tags and GPS details) and videos (retrieving codec, bitrate,
/// and streaming info), alongside recursive filesystem scanning tools.
library metadata_extractor;

export 'src/extractors/image_extractor.dart';
export 'src/extractors/video_extractor.dart';
export 'src/scanner/file_scanner.dart';
