# metadata_extractor

A powerful metadata extraction implementation for Flutter, enabling rich EXIF and media metadata retrieval across platforms. It provides recursive file scanning and specialized metadata extractors for different media types (images and videos).

## Features

- **Recursive File Scanning**: Easily scan local directories for media files with progress tracking.
- **Image Metadata Extraction**: Extract EXIF data including device brand, model, ISO, dimensions, and GPS coordinates.
- **Video Metadata Extraction**: Read rich video properties including duration, resolution, frame rate, and codec details.
- **Standardized Models**: Built on top of `metadata_core` for consistent typed interfaces.

## Getting started

Add `metadata_extractor` to your `pubspec.yaml`:

```yaml
dependencies:
  metadata_extractor: ^0.0.2
```

## Usage

### 1. Import the package

```dart
import 'package:metadata_extractor/metadata_extractor.dart';
import 'package:metadata_core/metadata_core.dart';
```

### 2. Scanning a Directory for Media Files

Scan a directory recursively to discover all media files and receive real-time progress updates:

```dart
final scanner = RecursiveFileScanner();

scanner.scan('/path/to/media/folder', recursive: true).listen((progress) {
  // Overall progress as a fraction between 0.0 and 1.0
  print('Progress: ${(progress.progress * 100).toStringAsFixed(1)}%');
  print('Processed: ${progress.processedFiles}/${progress.totalFiles}');

  if (progress.currentFile != null) {
    final file = progress.currentFile!;
    print('File name:      ${file.fileName}');
    print('MIME type:      ${file.mimeType}');
    print('Full path:      ${file.fullFilePath}');
    print('Relative path:  ${file.relativePath}');
    print('Size (bytes):   ${file.size}');
  }

  if (progress.status == 'Complete') {
    print('Scanning finished!');
  }
});
```

### 3. Scanning an Explicit List of Files

When you already have a list of file objects (e.g. on web via a file picker):

```dart
final scanner = RecursiveFileScanner();

scanner.scanFiles(pickedFiles).listen((progress) {
  print('Processing: ${progress.processedFiles}/${progress.totalFiles}');

  if (progress.status == 'Complete') {
    print('All files processed.');
  }
});
```

### 4. Extracting Image Metadata (EXIF)

Extract EXIF data — including location, camera settings, and device information — from a discovered image:

```dart
final imageExtractor = ImageMetadataExtractor();

if (imageExtractor.canHandle(mediaFile.mimeType)) {
  final MetadataResult result = await imageExtractor.extract(mediaFile);

  // Device info
  print('Brand:         ${result.device?.brand}');
  print('Model:         ${result.device?.model}');

  // GPS location
  print('Latitude:      ${result.location?.latitude}');
  print('Longitude:     ${result.location?.longitude}');

  // Image details
  final img = result.imageMetadata;
  print('Dimensions:    ${img?.width}x${img?.height}');
  print('Format:        ${img?.format}');
  print('Color space:   ${img?.colorSpace}');
  print('ISO:           ${img?.iso}');
  print('Exposure time: ${img?.exposureTime}s');
  print('Aperture:      f/${img?.fNumber}');
  print('Focal length:  ${img?.focalLength}mm');
  print('Software:      ${img?.software}');
}
```

### 5. Extracting Video Metadata

Extract rich video properties from a discovered video file using FFprobe:

```dart
final videoExtractor = VideoMetadataExtractor();

if (videoExtractor.canHandle(mediaFile.mimeType)) {
  final MetadataResult result = await videoExtractor.extract(mediaFile);

  final vid = result.videoMetadata;
  print('Duration:      ${vid?.duration}s');
  print('Dimensions:    ${vid?.width}x${vid?.height}');
  print('Frame rate:    ${vid?.fps} fps');
  print('Bitrate:       ${vid?.bitrate} bps');
  print('Video codec:   ${vid?.codec}');
  print('Audio codec:   ${vid?.audioCodec}');
}
```

## Model Reference

### `MediaFile`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique identifier |
| `fileName` | `String` | File name with extension |
| `path` | `String` | Absolute filesystem path |
| `fullFilePath` | `String?` | Full filesystem path (native) or relative folder path (web) |
| `thumbnailPath` | `String?` | Path to generated thumbnail, if available |
| `relativePath` | `String` | Path relative to the scanned root directory |
| `size` | `int` | File size in bytes |
| `mimeType` | `String` | MIME type (e.g. `image/jpeg`) |
| `createdAt` | `DateTime` | File creation timestamp |
| `modifiedAt` | `DateTime` | Last modified timestamp |
| `hash` | `String?` | SHA-256 hash for deduplication |
| `isCorrupted` | `bool` | Whether the file is unreadable |
| `isDuplicate` | `bool` | Whether the file is a duplicate |

### `MetadataResult`

| Field | Type | Description |
|---|---|---|
| `fileId` | `String` | ID of the associated `MediaFile` |
| `rawMetadata` | `Map<String, dynamic>` | Raw key-value pairs from the file |
| `imageMetadata` | `ImageMetadata?` | Image-specific metadata |
| `videoMetadata` | `VideoMetadata?` | Video-specific metadata |
| `location` | `LocationData?` | GPS coordinates and place info |
| `device` | `DeviceData?` | Capture device hardware info |

### `ScanProgress`

| Field | Type | Description |
|---|---|---|
| `totalFiles` | `int` | Total files identified |
| `processedFiles` | `int` | Files fully processed so far |
| `currentFile` | `MediaFile?` | File currently being processed |
| `metadata` | `MetadataResult?` | Extracted metadata for the current file |
| `status` | `String` | Human-readable status message |
| `progress` | `double` | Fraction complete (0.0–1.0) |

## Additional information

For more details on the core metadata models, please refer to the `metadata_core` package. Please refer to the issue tracker for reporting bugs or requesting features.
