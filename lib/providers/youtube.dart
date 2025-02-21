import 'package:flutter/material.dart';
import 'package:insightmate/model/youtube.dart';

class YoutubeProvider extends ChangeNotifier {
  YoutubeModel? _youtubeModel; // Nullable to handle no file case

  YoutubeModel? get youtubeModel => _youtubeModel;

  // Set file from JSON string
  void setYoutube(String fileJson) {
    debugPrint(fileJson);
    _youtubeModel = YoutubeModel.fromJson(fileJson);
    notifyListeners();
  }

  // Set file from youtubeModel object
  void setYoutubeFromModel(YoutubeModel youtubeModel) {
    _youtubeModel = youtubeModel;
    notifyListeners();
  }

  // Clear the file data
  void clearYoutube() {
    _youtubeModel = null;
    notifyListeners();
  }
}
