import 'package:flutter/material.dart';
import 'package:insightmate/model/file.dart';

class FileProvider extends ChangeNotifier {
  FileModel? _fileModel; // Nullable to handle no file case

  FileModel? get fileModel => _fileModel;

  // Set file from JSON string
  void setFile(String fileJson) {
    debugPrint(fileJson);
    _fileModel = FileModel.fromJson(fileJson);
    notifyListeners();
  }

  // Set file from FileModel object
  void setFileFromModel(FileModel fileModel) {
    _fileModel = fileModel;
    notifyListeners();
  }

  // Clear the file data
  void clearFile() {
    _fileModel = null;
    notifyListeners();
  }
}
