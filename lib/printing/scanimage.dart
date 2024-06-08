import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:path_provider/path_provider.dart';

class ScanDocumentPage extends StatefulWidget {
  const ScanDocumentPage({super.key});

  @override
  State<ScanDocumentPage> createState() => _ScanDocumentPageState();
}

class _ScanDocumentPageState extends State<ScanDocumentPage> {
  @override
  Widget build(BuildContext context) {
    return DocumentScanner(
      onSave: (Uint8List imageBytes) async {
        //pop with file
        String tempDirectory = (await getTemporaryDirectory()).path;
        File tempFile = File(
            '${tempDirectory}/${DateTime.now().millisecondsSinceEpoch}_scannedImage.png');
        await tempFile.writeAsBytes(imageBytes);
        Navigator.of(context).pop(tempFile);
      },
    );
  }
}
