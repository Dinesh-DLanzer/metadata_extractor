import 'package:metadata_core/metadata_core.dart';
import 'package:metadata_extractor/metadata_extractor.dart';

void main() async {
  print('=== MetaVision Metadata Extractor Example ===\n');

  // 1. Instantiate the scanner and extractors
  const scanner = RecursiveFileScanner();
  const imageExtractor = ImageMetadataExtractor();
  const videoExtractor = VideoMetadataExtractor();

  // 2. Define mock MediaFiles for demonstration
  final mockImageFile = MediaFile(
    id: 'photo_01',
    fileName: 'vacation.jpg',
    path: '/path/to/vacation.jpg',
    fullFilePath: '/path/to/vacation.jpg',
    relativePath: 'vacation.jpg',
    size: 409600,
    mimeType: 'image/jpeg',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    modifiedAt: DateTime.now().subtract(const Duration(hours: 2)),
  );

  final mockVideoFile = MediaFile(
    id: 'video_01',
    fileName: 'sunset.mp4',
    path: '/path/to/sunset.mp4',
    fullFilePath: '/path/to/sunset.mp4',
    relativePath: 'sunset.mp4',
    size: 25600000,
    mimeType: 'video/mp4',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    modifiedAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  final mockFiles = [mockImageFile, mockVideoFile];

  // 3. Demonstrate scanning a list of files using the scanner
  print('--- Scanning Simulated Files ---');
  await for (final progress in scanner.scanFiles(mockFiles)) {
    print('Progress: [${progress.processedFiles}/${progress.totalFiles}] - ${progress.status}');
  }
  print('');

  // 4. Demonstrate Image Metadata Extraction
  print('--- Image Extractor Demo ---');
  if (imageExtractor.canHandle(mockImageFile.mimeType)) {
    print('Image Extractor can handle: ${mockImageFile.fileName}');
    
    // In a real application, you would run:
    // final result = await imageExtractor.extract(mockImageFile);
    // Since this is a self-contained CLI demo, we show the structured output format:
    final sampleResult = MetadataResult(
      fileId: mockImageFile.id,
      device: const DeviceData(brand: 'Canon', model: 'EOS 5D Mark IV'),
      location: const LocationData(latitude: 35.6762, longitude: 139.6503),
      imageMetadata: const ImageMetadata(
        width: 6720,
        height: 4480,
        iso: 400,
        software: 'Digital Photo Professional',
      ),
      rawMetadata: {
        'Image Make': 'Canon',
        'Image Model': 'EOS 5D Mark IV',
        'EXIF ExifImageWidth': '6720',
        'EXIF ExifImageLength': '4480',
        'EXIF ISOSpeedRatings': '400',
      },
    );

    print('Brand: ${sampleResult.device?.brand}');
    print('Model: ${sampleResult.device?.model}');
    print('Dimensions: ${sampleResult.imageMetadata?.width} x ${sampleResult.imageMetadata?.height}');
    print('GPS: ${sampleResult.location?.latitude}, ${sampleResult.location?.longitude}');
  }
  print('');

  // 5. Demonstrate Video Metadata Extraction
  print('--- Video Extractor Demo ---');
  if (videoExtractor.canHandle(mockVideoFile.mimeType)) {
    print('Video Extractor can handle: ${mockVideoFile.fileName}');

    // In a real application, you would run:
    // final result = await videoExtractor.extract(mockVideoFile);
    // Showing simulated video extraction representation:
    final sampleResult = MetadataResult(
      fileId: mockVideoFile.id,
      videoMetadata: const VideoMetadata(
        duration: 12.45,
        width: 1920,
        height: 1080,
        fps: 60.0,
        bitrate: 15000,
        codec: 'h264',
      ),
    );

    print('Duration: ${sampleResult.videoMetadata?.duration} seconds');
    print('Codec: ${sampleResult.videoMetadata?.codec}');
    print('Dimensions: ${sampleResult.videoMetadata?.width} x ${sampleResult.videoMetadata?.height}');
    print('Frame Rate: ${sampleResult.videoMetadata?.fps} fps');
  }
}
