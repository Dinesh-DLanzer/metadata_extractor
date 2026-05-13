import 'dart:io';
import 'package:exif/exif.dart';
import 'package:metadata_core/metadata_core.dart';

class ImageMetadataExtractor implements IMetadataExtractor {
  @override
  bool canHandle(String mimeType) {
    return mimeType.startsWith('image/');
  }

  @override
  Future<MetadataResult> extract(MediaFile file) async {
    final bytes = await File(file.path).readAsBytes();
    final data = await readExifFromBytes(bytes);

    if (data.isEmpty) {
      return MetadataResult(fileId: file.id);
    }

    final brand = data['Image Make']?.toString();
    final model = data['Image Model']?.toString();
    
    // GPS Extraction
    double? lat, lng;
    if (data.containsKey('GPS GPSLatitude')) {
      lat = _convertToDecimal(data['GPS GPSLatitude']!.values.toList(), data['GPS GPSLatitudeRef']!.toString());
      lng = _convertToDecimal(data['GPS GPSLongitude']!.values.toList(), data['GPS GPSLongitudeRef']!.toString());
    }

    return MetadataResult(
      fileId: file.id,
      rawMetadata: data.map((key, value) => MapEntry(key, value.toString())),
      imageMetadata: ImageMetadata(
        width: int.tryParse(data['EXIF ExifImageWidth']?.toString() ?? ''),
        height: int.tryParse(data['EXIF ExifImageLength']?.toString() ?? ''),
        iso: int.tryParse(data['EXIF ISOSpeedRatings']?.toString() ?? ''),
        software: data['Image Software']?.toString(),
      ),
      device: DeviceData(brand: brand, model: model),
      location: lat != null && lng != null ? LocationData(latitude: lat, longitude: lng) : null,
    );
  }

  double _convertToDecimal(List<dynamic> values, String ref) {
    double degrees = values[0].toDouble();
    double minutes = values[1].toDouble();
    double seconds = values[2].toDouble();

    double decimal = degrees + (minutes / 60.0) + (seconds / 3600.0);
    if (ref == 'S' || ref == 'W') decimal = -decimal;
    return decimal;
  }
}
