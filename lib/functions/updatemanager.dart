import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../config.dart' as config;

class UpdateManager {
  var currentVersion = int.parse(config.version.toString().replaceAll(".", ""));

  FutureOr<bool> checkForUpdate() async {
    bool hasUpdate =
        await get(Uri.parse("https://flowei.tech/projects/samcam/currver.json"))
            .then((value) {
      var data = json.decode(value.body);

      int newestVersion =
          int.parse(data["version"].toString().replaceAll(".", ""));

      print("Newest version: " + newestVersion.toString());

      print("Current version: " + currentVersion.toString());

      if (newestVersion > currentVersion) {
        launch("https://flowei.tech/samcamupdate");
        return true;
      } else {
        return false;
      }
    });
    return hasUpdate;
  }
}
