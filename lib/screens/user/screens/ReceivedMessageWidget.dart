import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';

class ReceivedMessageWidget extends StatelessWidget {
  final String content;
  final String imageAddress;
  final String time;
  final bool isImage;

  const ReceivedMessageWidget({
    Key key,
    this.content,
    this.time,
    this.isImage,
    this.imageAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 8.0, top: 4.0, bottom: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  child: LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width * .60,
                    child: Container(
                      color: HexColor("#F7F8F9"),
                      // margin: const EdgeInsets.only(left: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top:4,bottom: 4,left: 4,right: 4),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              !isImage
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0,
                                          left: 8.0,
                                          top: 8.0,
                                          bottom: 4.0),
                                      child: Text(
                                        content,
                                        style:
                                            TextStyle(color: HexColor("#3E4958")),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0,
                                          left: 8.0,
                                          top: 8.0,
                                          bottom: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Text(
                                            content,
                                            style: TextStyle(color: Colors.white),
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
          ),              Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
    /* Container(
        child: Padding(
          padding:
          const EdgeInsets.only(right: 320.0, left: 8.0, top: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
          color: Colors.red,
          child: Stack(
            children: <Widget>[
              !isImage
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                      child: Text(
                        content,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Image.asset(
                              imageAddress,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
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
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 10, color: Colors.black.withOpacity(0.6)),
                ),
              )
            ],
          ),
        ),
      ),
    ));*/
  }
}
