import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final Function onPressed;

  const BotonAzul({Key key, this.text, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      //highlightColor: Colors.blue,
      color: Colors.blue,
      highlightElevation: 5,
      shape: StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        child: Center(
          child: Text(this.text, style: TextStyle( color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }
}