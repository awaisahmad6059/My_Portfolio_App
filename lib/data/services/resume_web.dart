import 'dart:typed_data';
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' show AnchorElement, Blob, Url, window;

class ResumeWebHelper {
  static void downloadPdf(Uint8List bytes, String fileName) {
    final blob = Blob(<Object>[bytes], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', fileName);
    anchor.click();
    Url.revokeObjectUrl(url);
  }

  static void openPdfInNewTab(Uint8List bytes, String fileName) {
    final blob = Blob(<Object>[bytes], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    window.open(url, '_blank');
  }
}
