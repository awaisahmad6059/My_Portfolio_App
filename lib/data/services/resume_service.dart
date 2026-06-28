import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:aak/data/services/resume_web_stub.dart'
    if (dart.library.html) 'package:aak/data/services/resume_web.dart';

class ResumeService {
  static const String _resumeFileName = 'resume.pdf';

  Future<String?> pickAndSavePdf() async {
    try {
      debugPrint('[ResumeService] Opening file picker for PDF...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('[ResumeService] File picker returned null (user cancelled)');
        return null;
      }

      final pickedFile = result.files.single;
      debugPrint(
        '[ResumeService] File picked: name=${pickedFile.name}, '
        'size=${pickedFile.size}, extension=${pickedFile.extension}',
      );

      if (pickedFile.extension?.toLowerCase() != 'pdf') {
        debugPrint('[ResumeService] Invalid file type: ${pickedFile.extension}');
        return null;
      }

      Uint8List? bytes = pickedFile.bytes;
      if (bytes == null && pickedFile.path != null) {
        debugPrint('[ResumeService] bytes was null, reading from path: ${pickedFile.path}');
        final fileOnDisk = File(pickedFile.path!);
        if (await fileOnDisk.exists()) {
          bytes = await fileOnDisk.readAsBytes();
          debugPrint('[ResumeService] Read ${bytes.length} bytes from path');
        } else {
          debugPrint('[ResumeService] File at path does not exist: ${pickedFile.path}');
          return null;
        }
      }

      if (bytes == null || bytes.isEmpty) {
        debugPrint('[ResumeService] Could not read file bytes (null or empty)');
        return null;
      }

      if (kIsWeb) {
        final base64Str = base64Encode(bytes);
        debugPrint('[ResumeService] Encoded PDF as base64 (${base64Str.length} chars)');
        return 'base64:$base64Str';
      }

      final dir = await getApplicationDocumentsDirectory();
      final permanentFile = File('${dir.path}/$_resumeFileName');
      debugPrint('[ResumeService] Writing ${bytes.length} bytes to: ${permanentFile.path}');

      await permanentFile.writeAsBytes(bytes, flush: true);

      final savedPath = permanentFile.path;
      if (!await permanentFile.exists()) {
        debugPrint('[ResumeService] ERROR: File was not saved correctly after write!');
        return null;
      }

      debugPrint('[ResumeService] Resume saved successfully to: $savedPath');
      return savedPath;
    } catch (e, stack) {
      debugPrint('[ResumeService] Error picking/saving PDF: $e');
      debugPrint('[ResumeService] Stack trace: $stack');
      return null;
    }
  }

  Future<bool> hasExistingFile(String storedData) async {
    if (kIsWeb) {
      return storedData.startsWith('base64:') && storedData.length > 7;
    }
    final file = File(storedData);
    return file.existsSync();
  }

  Future<bool> openResume(String storedData) async {
    if (kIsWeb) {
      try {
        final base64Str = storedData.startsWith('base64:')
            ? storedData.substring(7)
            : storedData;
        final bytes = base64Decode(base64Str);
        ResumeWebHelper.openPdfInNewTab(bytes, _resumeFileName);
        return true;
      } catch (e, stack) {
        debugPrint('[ResumeService] Web openResume error: $e');
        debugPrint('[ResumeService] Stack trace: $stack');
        return false;
      }
    }

    try {
      debugPrint('[ResumeService] Opening resume at path: $storedData');
      final file = File(storedData);
      if (!await file.exists()) {
        debugPrint('[ResumeService] Resume file no longer exists: $storedData');
        return false;
      }
      final result = await OpenFilex.open(storedData);
      final success = result.type == ResultType.done;
      debugPrint('[ResumeService] Open result: ${result.type} - ${result.message}');
      return success;
    } catch (e, stack) {
      debugPrint('[ResumeService] Error opening resume: $e');
      debugPrint('[ResumeService] Stack trace: $stack');
      return false;
    }
  }

  Future<void> shareResume(String storedData) async {
    if (kIsWeb) {
      debugPrint('[ResumeService] Share not supported on web, downloading instead');
      await downloadResume(storedData);
      return;
    }

    try {
      debugPrint('[ResumeService] Sharing resume at path: $storedData');
      final file = File(storedData);
      if (!await file.exists()) {
        debugPrint('[ResumeService] Resume file no longer exists, cannot share: $storedData');
        return;
      }
      await Share.shareXFiles([XFile(storedData)], text: 'My Resume');
      debugPrint('[ResumeService] Share completed successfully');
    } catch (e, stack) {
      debugPrint('[ResumeService] Error sharing resume: $e');
      debugPrint('[ResumeService] Stack trace: $stack');
    }
  }

  Future<void> downloadResume(String storedData) async {
    if (kIsWeb) {
      try {
        final base64Str = storedData.startsWith('base64:')
            ? storedData.substring(7)
            : storedData;
        final bytes = base64Decode(base64Str);
        ResumeWebHelper.downloadPdf(bytes, _resumeFileName);
        debugPrint('[ResumeService] Web download completed');
      } catch (e, stack) {
        debugPrint('[ResumeService] Web download error: $e');
        debugPrint('[ResumeService] Stack trace: $stack');
      }
      return;
    }

    try {
      debugPrint('[ResumeService] Downloading (sharing) resume at path: $storedData');
      final file = File(storedData);
      if (!await file.exists()) {
        debugPrint('[ResumeService] Resume file not found for download: $storedData');
        return;
      }
      await Share.shareXFiles([XFile(storedData)], text: 'My Resume');
    } catch (e, stack) {
      debugPrint('[ResumeService] Error downloading resume: $e');
      debugPrint('[ResumeService] Stack trace: $stack');
    }
  }
}
