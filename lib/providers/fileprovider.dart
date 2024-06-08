import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class FileShareProvider extends ChangeNotifier {
  List<SharedMediaFile> sharedFiles = [];

  FileShareProvider();

  void changeFileShared(List<SharedMediaFile> newSharedFiles) {
    sharedFiles = newSharedFiles;

    notifyListeners();
  }
}
