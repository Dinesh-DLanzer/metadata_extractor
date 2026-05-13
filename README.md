# metadata_extractor

A powerful metadata extraction implementation for Flutter, enabling rich EXIF and media metadata retrieval across platforms. It provides recursive file scanning and specialized metadata extractors for different media types (images and videos).

## Features

- **Recursive File Scanning**: Easily scan local directories for media files with progress tracking.
- **Image Metadata Extraction**: Extract EXIF data including device brand, model, ISO, dimensions, and GPS coordinates.
- **Video Metadata Extraction**: Read rich video properties.
- **Standardized Models**: Built on top of `metadata_core` for consistent typed interfaces.

## Getting started

Add `metadata_extractor` to your `pubspec.yaml`:

```yaml
dependencies:
  metadata_extractor: ^0.0.1
```

## Usage

### 1. Import the package

```dart
import 'package:metadata_extractor/metadata_extractor.dart';
import 'package:metadata_core/metadata_core.dart';
```

### 2. Scanning a Directory for Media Files

You can scan a directory recursively to discover all media files and receive real-time progress:

```dart
final scanner = RecursiveFileScanner();

// Listen to the scan stream
scanner.scan('/path/to/media/folder', recursive: true).listen((progress) {
  print('Processed: ${progress.processedFiles}/${progress.totalFiles}');
  
  if (progress.currentFile != null) {
    print('Found file: ${progress.currentFile!.fileName}');
    print('MIME type: ${progress.currentFile!.mimeType}');
  }
  
  if (progress.status == 'Complete') {
    print('Scanning finished!');
  }
});
```

### 3. Extracting Image Metadata (EXIF)

To extract EXIF data (including location, dimensions, and device information) from a discovered image:

```dart
final imageExtractor = ImageMetadataExtractor();

// Assuming `mediaFile` is obtained from the scanner
if (imageExtractor.canHandle(mediaFile.mimeType)) {
  MetadataResult result = await imageExtractor.extract(mediaFile);
  
  // Access strongly-typed metadata
  print('Device: ${result.device?.brand} ${result.device?.model}');
  print('Location: ${result.location?.latitude}, ${result.location?.longitude}');
  print('Dimensions: ${result.imageMetadata?.width}x${result.imageMetadata?.height}');
}
```

## Additional information

For more details on the core metadata models, please refer to the `metadata_core` package. Please refer to the issue tracker for reporting bugs or requesting features.
