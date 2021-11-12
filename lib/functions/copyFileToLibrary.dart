import 'dart:io';
import 'package:flutter/material.dart';

import '../config.dart' as config;

Future<String> copyFileToLibrary(String path, dynamic context) async {
  List splitPath = path.split("/");
  String fileName = splitPath[splitPath.length - 1];
  String newPath = "/storage/emulated/0/Pictures/samcam/" + fileName;

  try {
    await File(path).copy(newPath);
    config.sendNotification(config.channelSpecificsFotoGeschpeichert,
        "Foto gespeichert", "Tippe zum öffnen", "open-path " + newPath);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Foto wurde gespeichert.')));
    return newPath;
  } on FileSystemException catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto konnte nicht gespeichert werden.')));
    return null;
  }
}
