import 'package:flutter/material.dart';
import 'package:insightmate/model/web.dart';

class WebProvider extends ChangeNotifier {
  WebModel? _webModel; // Nullable to handle no file case

  WebModel? get webModel => _webModel;

  // Set file from JSON string
  void setFile(String fileJson) {
    debugPrint(fileJson);
    _webModel = WebModel.fromJson(fileJson);
    notifyListeners();
  }

  // Set file from webModel object
  void setFileFromModel(WebModel webModel) {
    _webModel = webModel;
    notifyListeners();
  }

  // Clear the file data
  void clearFile() {
    _webModel = null;
    notifyListeners();
  }
}
