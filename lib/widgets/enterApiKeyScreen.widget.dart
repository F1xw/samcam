import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewcontainer.dart';
import 'package:http/http.dart';
import 'dart:io';

class EnterAPIKeyScreen extends StatefulWidget {
  @override
  _EnterAPIKeyScreenState createState() => _EnterAPIKeyScreenState();
}

class _EnterAPIKeyScreenState extends State<EnterAPIKeyScreen> {
  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  void checkAPIKey() async {
    var apiKey = textController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future request = get(
      Uri.https('api.flowei.tech', 'sammy/weight/'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );

    request.then((response) async {
      if (response.statusCode != 200 && response.statusCode != 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Dein API Key funktioniert nicht :(")));
      } else {
        await prefs.setBool('seen', true);
        await prefs.setString("apiKey", apiKey);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new ViewContainer()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFFA134EB),
                  const Color(0xFFcf99ab),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Bitte gib deinen API Key ein!',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Helvetica",
                        color: Colors.white,
                        decoration: TextDecoration.none)),
                Divider(color: Color(0x00000000)),
                Divider(color: Color(0x00000000)),
                Container(
                  width: 300.0,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 4.0)),
                        hintText: 'API key'),
                    controller: textController,
                  ),
                )
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: checkAPIKey,
        child: const Icon(Icons.navigate_next_rounded),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
