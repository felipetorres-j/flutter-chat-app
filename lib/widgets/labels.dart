import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final String title;
  final String subtitle;

  const Labels({Key key, @required this.ruta, this.title, this.subtitle}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
          SizedBox(height: 10),
          GestureDetector(
            child: Text(subtitle, style: TextStyle(color: Colors.blue[300], fontSize: 18, fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.pushReplacementNamed(context, this.ruta);
            },
          ),
        ],
      )
    );
  }
}