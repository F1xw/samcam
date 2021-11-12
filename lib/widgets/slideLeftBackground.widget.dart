import 'package:flutter/material.dart';

Widget slideLeftBackground() {
  return Container(
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ClipOval(
              child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.red),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
