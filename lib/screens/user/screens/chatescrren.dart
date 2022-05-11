import 'dart:convert';

import 'package:aim_cab/screens/common/Varibles.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'ReceivedMessageWidget.dart';
import 'SendedMessageWidget.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Socket socket;

  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  var childList = <Widget>[];
  String userid;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // connectToServer();
      createroomchate();
    });
    print(Varibles.SendID);
    print(Varibles.SenderName);
    print(Varibles.ReciveID);
    print(Varibles.ReciverName);

    /*childList.add(Align(
        alignment: Alignment(0, 0),
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 25,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
          child: Center(
              child: Text(
                "Today",
                style: TextStyle(fontSize: 11),
              )),
        )));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'Hello',
        time: 'Time',
        isImage: false,
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content: 'How are you? What are you doing?',
        time: 'Time',
        isImage: false,
      ),
    ));
    childList.add(Align(
      alignment: Alignment(-1, 0),
      child: ReceivedMessageWidget(
        content: 'Hello, Mohammad.I am fine. How are you?',
        time: 'Time',
        isImage: false,
      ),
    ));
    childList.add(Align(
      alignment: Alignment(1, 0),
      child: SendedMessageWidget(
        content:
        'I am good. Can you do something for me? I need your help my bro.',
        time: 'Time',
        isImage: false,
      ),
    ));*/
  }

  void connectToServer() {
    //print("DIDIDIDIDI:" + userid);
    try {
      // Configure socket transports must be sepecified
      //ws://aim.inawebtech.com
      socket = io('http://aim.inawebtech.com/socket_chat', <String, dynamic>{
        'transports': ['websocket'],
        'query': {"id": Varibles.SendID},
        'autoConnect': true,
      });
      socket.connect();

      socket.onConnect((data) => {
            print(socket.ids),
            print("Socket Connnection :" + socket.connected.toString())
          });
      socket.on("OnMessageRecived", (data) {
        print('OnMessageRecived===========$data');
        if (data["Message"] == Varibles.SendID) {
          setState(() {
            childList.add(Align(
              alignment: Alignment(1, 0),
              child: SendedMessageWidget(
                content: data["Message"],
                time: data["Time"],
                isImage: false,
              ),
            ));
          });
        } else {
          setState(() {
            childList.add(Align(
              alignment: Alignment(1, 0),
              child: ReceivedMessageWidget(
                content: data["Message"],
                time: data["Time"],
                isImage: false,
              ),
            ));
          });
        }
      });
    } catch (e) {
      print("socket_error:" + e.toString());
    }
  }

  Future<dynamic> createroomchate() async {
    var dio = Dio();
    var token = await getToken();

    var resp = await dio.post(
      'http://aim.inawebtech.com/v1.0/create-room',
      data: {
        "SenderId": Varibles.SendID,
        "ReceiverId": Varibles.ReciveID,
        "SenderName": Varibles.SenderName,
        "ReceiverName": Varibles.ReciverName,
        "SenderPhoto":
            'http://aim.inawebtech.com/assets/profile/avatar-icon.png',
        "ReceiverPhoto":
            'http://aim.inawebtech.com/assets/profile/avatar-icon.png',
      },
      options: Options(
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json',
        },
      ),
    );
    String msg = jsonDecode(json.encode(resp.data))['msg'].toString();
    print("roomissss==:" + resp.data.toString());
    connectToServer();

    if (msg == 'room created') {
      String data = jsonDecode(json.encode(resp.data))['data'].toString();
      String _id = jsonDecode(json.encode(data))['_id'].toString();
      print("roomissss==:" + _id.toString());
    } else {}
  }

  Future<dynamic> SendMessage(String msgtype) async {
    var dio = Dio();
    var token = await getToken();

    var resp = await dio.post(
      'http://aim.inawebtech.com/v1.0/send-messages/' + Varibles.SendID,
      data: {
        "message": [
          {
            "SenderId": Varibles.SendID,
            "ReceiverId": Varibles.ReciveID,
            "SenderName": Varibles.SenderName,
            "ReceiverName": Varibles.ReciverName,
            "Message": msgtype,
            "FilePath":
                "http://aim.inawebtech.com/assets/documents/1631451907478.jpg",
            "MimeType": "image"
          }
        ]
      },
      options: Options(
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json',
        },
      ),
    );
    String msg = jsonDecode(json.encode(resp.data))['msg'].toString();
    //  print("sendmessge==:" + msg.toString());
/*
    setState(() {
      childList.add(Align(
        alignment: Alignment(1, 0),
        child: SendedMessageWidget(
          content: msgtype,
          time: 'Time',
          isImage: false,
        ),
      ));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Container(height: 10),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                height: 50,
                                child: Neumorphic(
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Patrick",
                                style: GoogleFonts.poppins(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              ),
                              Text(
                                "online",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Container(
                              child: ClipRRect(
                                child: Container(
                                    child: SizedBox(
                                      child: Image.asset(
                                        "assets/images/driver_online.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    color: Colors.green),
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(0.0),
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5.0,
                                        spreadRadius: -1,
                                        offset: Offset(0.0, 5.0))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      /*decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/chat-background-1.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),*/
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          // reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: childList,
                          )),
                    ),
                  ),
                  Divider(height: 0, color: Colors.black26),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        maxLines: 20,
                        controller: _text,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  if(_text.text!="") {
                                    SendMessage(_text.text);
                                    //  _text.clear();
                                    DateTime times = DateTime.now();
                                    final DateFormat formatter =
                                    DateFormat('hh:mm a ');
                                    final String tt =
                                    formatter.format(times).toString();
                                    socket.emit('OnMessageSend', {
                                      {
                                        "SenderId": Varibles.SendID,
                                        "ReceiverId": Varibles.ReciveID,
                                        "SenderName": Varibles.SenderName,
                                        "ReceiverName": Varibles.ReciverName,
                                        "Message": _text.text,
                                        "FilePath": "",
                                        "Time": "$tt"
                                      }

                                      /*{
                                      "SenderId":Varibles.SendID,
                                      "ReceiverId":Varibles.ReciveID,
                                      "SenderName":"pooja sarkar",
                                      "ReceiverName":"Arjun Shah",
                                      "SenderPhoto":"http://aim.inawebtech.com/assets/profile/avatar-icon.png",
                                      "ReceiverPhoto":"http://aim.inawebtech.com/assets/profile/avatar-icon.png"
                                    }*/
                                    });
                                    setState(() {
                                      childList.add(Align(
                                        alignment: Alignment(1, 0),
                                        child: SendedMessageWidget(
                                          content: _text.text,
                                          time: '$tt',
                                          isImage: false,
                                        ),
                                      ));
                                    });
                                    _text.clear();
                                  }
                                },
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          hintText: "  Enter your message",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
