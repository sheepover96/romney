import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final String word;

  Detail({@required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('詳細')),
        body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: FractionallySizedBox(
                  alignment: Alignment.center,
                  widthFactor: 0.95,
                  heightFactor: 0.7,
                  child: Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                          // margin: EdgeInsets.all(15.0),
                          margin: EdgeInsets.only(
                              top: 15.0, left: 20.0, right: 20.0, bottom: 15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      this.word,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 12),
                                    Text("ヤッホー")
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("This is description"),
                              ])))),
            )));
  }
}
