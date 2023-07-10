import 'package:flutter/material.dart';
import 'enterApiKeyScreen.widget.dart';

class IntroScreen extends StatelessWidget {
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
                Image(image: AssetImage('lib/icon.png'), width: 70),
                Divider(color: Color(0x00000000)),
                Divider(color: Color(0x00000000)),
                Text('Willkommen bei SamCam!',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Helvetica",
                        color: Colors.white,
                        decoration: TextDecoration.none)),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: 7, minute: 15),
          ); //Navigator.of(context).pushReplacement(new MaterialPageRoute(
          //builder: (context) => new EnterAPIKeyScreen()));
        },
        child: const Icon(Icons.navigate_next_rounded),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
