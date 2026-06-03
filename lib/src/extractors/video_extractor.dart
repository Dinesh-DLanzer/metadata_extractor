import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:metadata_core/metadata_core.dart';

/// An extractor implementation that processes video files and retrieves
/// media information such as duration, resolution, frame rate, and codecs
/// using the FFprobe tool.
class VideoMetadataExtractor implements IMetadataExtractor {
  /// Creates a new instance of [VideoMetadataExtractor].
  const VideoMetadataExtractor();

  /// Determines if this extractor can process a given [mimeType].
  ///
  /// Returns `true` if the MIME type starts with 'video/'.
  @override
  bool canHandle(String mimeType) {
    return mimeType.startsWith('video/');
  }

  /// Extracts rich video metadata from the provided [file].
  ///
  /// Leverages [FFprobeKit] to gather details such as codec,
  /// average frame rate, duration, and resolution streams.
  @override
  Future<MetadataResult> extract(MediaFile file) async {
    final session = await FFprobeKit.getMediaInformation(file.path);
    final information = session.getMediaInformation();

    if (information == null) {
      return MetadataResult(fileId: file.id);
    }

    final duration = double.tryParse(information.getDuration() ?? '0') ?? 0.0;
    final streams = information.getStreams();

    int? width, height;
    double? fps;
    String? codec;

    for (var stream in streams) {
      if (stream.getType() == 'video') {
        width = stream.getWidth();
        height = stream.getHeight();
        fps = double.tryParse(stream.getAverageFrameRate() ?? '0');
        codec = stream.getCodec();
        break;
      }
    }

    return MetadataResult(
      fileId: file.id,
      videoMetadata: VideoMetadata(
        duration: duration,
        width: width ?? 0,
        height: height ?? 0,
        fps: fps ?? 0.0,
        bitrate: int.tryParse(information.getBitrate() ?? '0') ?? 0,
        codec: codec,
      ),
    );
  }
}
