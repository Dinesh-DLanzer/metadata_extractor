import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:metadata_core/metadata_core.dart';

class RecursiveFileScanner implements IFileScanner {
  @override
  Stream<ScanProgress> scan(String path, {bool recursive = true}) async* {
    final directory = Directory(path);
    if (!await directory.exists()) {
      yield ScanProgress(totalFiles: 0, processedFiles: 0, status: 'Directory not found');
      return;
    }

    final List<File> files = [];
    yield ScanProgress(totalFiles: 0, processedFiles: 0, status: 'Counting files...');
    
    await for (final entity in directory.list(recursive: recursive, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }

    int processed = 0;
    for (final file in files) {
      processed++;
      final stat = await file.stat();
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      
      final mediaFile = MediaFile(
        id: processed.toString(), // Simplified ID
        fileName: p.basename(file.path),
        path: file.path,
        relativePath: p.relative(file.path, from: path),
        size: stat.size,
        mimeType: mimeType,
        createdAt: stat.changed,
        modifiedAt: stat.modified,
      );

      yield ScanProgress(
        totalFiles: files.length,
        processedFiles: processed,
        currentFile: mediaFile,
        status: 'Scanning: ${mediaFile.fileName}',
      );
    }
    yield ScanProgress(totalFiles: files.length, processedFiles: processed, status: 'Complete');
  }

  @override
  Stream<ScanProgress> scanFiles(List<dynamic> files) async* {
    int total = files.length;
    int processed = 0;
    for (var file in files) {
      processed++;
      yield ScanProgress(
        totalFiles: total,
        processedFiles: processed,
        status: 'Processing: ${file.name}',
      );
    }
    yield ScanProgress(totalFiles: total, processedFiles: processed, status: 'Complete');
  }
}
