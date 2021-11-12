import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../functions/api.dart';

import '../config.dart' as config;

class LiveView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LiveViewState();
  }
}

class _LiveViewState extends State<LiveView> {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  Api api = new Api(config.apiKey);

  @override
  Widget build(BuildContext context) {
    bool streamError = false;
    final photoErrorSnackbar =
        SnackBar(content: Text('Foto kann nicht erstellt werden.'));

    final photoSuccessSnackbar =
        SnackBar(content: Text('Foto wurde erstellt!'));

    streamLoadingError(con, dyn, dyn2) {
      // streamError = true;

      return (con, dyn, dyn2) => Container(
            alignment: Alignment.center,
            child: Text("Livestream konnte nicht geladen werden"),
          );
    }

    Future<String> networkImageToBase64() async {
      http.Response response = await http.get(Uri.parse(
          "https://samcamclient:TQB02xC7hVc2P!FX4j4mpMsGKj&1GFo9@hsh.flowei.tech/hooks/samcam/samcamsnap.php"));
      final bytes = response?.bodyBytes;
      return (bytes != null ? base64Encode(bytes) : null);
    }

    void takePhoto() async {
      if (streamError == true) {
        ScaffoldMessenger.of(context).showSnackBar(photoErrorSnackbar);
      } else {
        var base64 = {"base64string": await networkImageToBase64()};
        var result = await api.insertImage(base64);

        if (result["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(photoSuccessSnackbar);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(photoErrorSnackbar);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Livestream')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ])),
        ),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          height: 300,
          child: ClipRRect(
            child: Mjpeg(
              isLive: true,
              stream: "https://" +
                  config.apiUrl +
                  "/sammy/stream?token=" +
                  config.apiKey,
              error: streamLoadingError(BuildContext, dynamic, dynamic),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Text(
          DateFormat("dd.MM.yyy").format(DateTime.now()),
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.lightBlue, fontSize: 27.0),
        ),
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Center(
              child: Text(
                DateFormat('HH:mm:ss').format(DateTime.now()),
                style: TextStyle(color: Colors.grey, fontSize: 20.0),
              ),
            );
          },
        ),
        SizedBox(
          height: 170,
        ),
        ClipOval(
            child: MaterialButton(
          onPressed: takePhoto,
          onLongPress: () {
            Random random = new Random();
            int randomNumber = random.nextInt(1000);
            config.sendNotification(config.channelSpecificsFotoGeschpeichert,
                "Sammys Zufallszahl:", randomNumber.toString(), "eastereggs");
          },
          padding: EdgeInsets.all(15),
          height: 80,
          minWidth: 80,
          color: Theme.of(context).primaryColor,
          child: Icon(
            Icons.camera,
            color: Colors.white,
            size: 43,
          ),
        )),
      ]),
    );
  }
}
