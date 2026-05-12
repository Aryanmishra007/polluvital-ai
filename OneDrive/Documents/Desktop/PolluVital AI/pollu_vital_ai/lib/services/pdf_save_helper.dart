import 'dart:typed_data';

import 'pdf_save_helper_stub.dart'
    if (dart.library.io) 'pdf_save_helper_io.dart'
    if (dart.library.html) 'pdf_save_helper_web.dart' as impl;

Future<String> savePdfBytes(String filename, Uint8List bytes) {
  return impl.savePdfBytes(filename, bytes);
}