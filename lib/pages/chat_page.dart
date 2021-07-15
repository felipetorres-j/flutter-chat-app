import 'dart:ffi';
import 'dart:io';

import 'package:chatapp/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> _messages = [];

  bool _enviarTexto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox( height: 3),
            Text('Ejemplo chat', style: TextStyle(color: Colors.black, fontSize: 12),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
                )
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        )
      )
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto){
                setState(() {
                  if (texto.trim().length > 0){
                    _enviarTexto = true;
                  }
                  else{
                    _enviarTexto = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar Mensaje'
              ),
              focusNode: _focusNode,
            )
          ),
          Container(
            margin: EdgeInsets.symmetric( horizontal: 4),
            child: Platform.isIOS
            ? CupertinoButton(
              child: Text("Enviar"),
              onPressed: _enviarTexto ? () => _handleSubmit(_textController.text) : null,
            ): Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconTheme(
                data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send),
                    onPressed: _enviarTexto ? () => _handleSubmit(_textController.text) : null,
                ),
              )
            )
          )
        ],
        ),
      )
      );
  }

  _handleSubmit(String texto){
    print(texto);
    if(texto.length == 0) return;
     _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(uid:'123', texto: texto, animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),);
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _enviarTexto = false;
    });
    
    @override
    void dispose(){
      //TODO: OFF SOCKET

      for(ChatMessage message in _messages){
        message.animationController.dispose();
      }
      super.dispose();
    }
  }
}