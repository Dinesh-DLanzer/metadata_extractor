## 0.0.3

* Adopt `metadata_core` 0.0.5: populate the new `MediaFile.fullFilePath` field in `RecursiveFileScanner`.
* Expand README with video extraction section, `scanFiles()` example, full `ImageMetadata` field coverage, `ScanProgress` fields, and Model Reference tables.
* Fix version constraint in README getting-started snippet (`^0.0.1` → `^0.0.2`).

## 0.0.2

* Modernized all dependencies to the latest versions.
* Replaced discontinued `ffmpeg_kit_flutter` with the community-maintained `ffmpeg_kit_flutter_new` drop-in replacement.
* Upgraded `mime` dependency to version `^2.0.0` to support modern mime-type definitions.
* Completed 100% public API documentation coverage with detailed Dartdocs.
* Added a clean Dart CLI example under `example/example.dart` demonstrating metadata extraction and scanning.

## 0.0.1

* Initial release of `metadata_extractor`.
* Core extraction logic for images and videos.
