import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendedMessageWidget extends StatelessWidget {
  final String content;
  final String imageAddress;
  final String time;
  final bool isImage;
  const SendedMessageWidget({
    Key key,
    this.content,
    this.time,
    this.imageAddress,
    this.isImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 8.0, top: 14.0, bottom: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(23),
                      bottomRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(0)),
                  child: LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width * .60,
                    child: Container(
                      color: HexColor("#1B4670"),
                      // margin: const EdgeInsets.only(left: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top:4,bottom: 4,left: 4,right: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              !isImage
                                  ? Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0, top: 8.0, bottom: 4.0),
                                child: Text(
                                  content,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                                  : Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        child: Image.asset(
                                          imageAddress,
                                          height: 130,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),*/
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        content,
                                        style: TextStyle(color:Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              /* Positioned(
                            bottom: 1,
                            right: 10,
                            child: Text(
                              "04:50 am",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white.withOpacity(0.6)),
                            ),
                          )*/
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0,left: 12),
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 10, color:HexColor("#97ADB6")),
                ),
              ),
            ],
          )

        ],
      ),
    );

    /*Container(
      child: Padding(
        padding: const EdgeInsets.only(
            right: 8.0, left: 50.0, top: 4.0, bottom: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          child: Container(
            color: Colors.blue,
            // margin: const EdgeInsets.only(left: 10.0),
            child: Stack(children: <Widget>[
              !isImage
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, left: 23.0, top: 8.0, bottom: 15.0),
                      child: Text(
                        content,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, left: 23.0, top: 8.0, bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          *//*ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Image.asset(
                              imageAddress,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),*//*
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            content,
                          )
                        ],
                      ),
                    ),
              Positioned(
                bottom: 1,
                left: 10,
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 10, color: Colors.black.withOpacity(0.6)),
                ),
              )
            ]),
          ),
        ),
      ),
    );*/
  }
}
