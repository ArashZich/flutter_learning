import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        elevation: 15,
        actions: <Widget>[
          PopupMenuButton<String>(itemBuilder: (BuildContext context) {
            return {'Profile', 'Setting', 'LogOut'}.map((String choise) {
              return PopupMenuItem(child: Text(choise), value: choise);
            }).toList();
          })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/back.jpg'), fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                            onPressed: () {}, child: Text('find')),
                      ),
                      Expanded(
                          child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Enter city'),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Mountain View',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Clear Sky',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Icon(Icons.wb_sunny_outlined,
                      color: Colors.white, size: 80),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text('14' + "\u00B0",
                      style: TextStyle(color: Colors.white, fontSize: 60)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'max',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '16' + "\u00B0",
                            style: TextStyle(
                                color: Colors.grey[200], fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 40,
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'min',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '12' + "\u00B0",
                            style: TextStyle(
                                color: Colors.grey[200], fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int pos) {
                          return Container(
                            height: 50,
                            width: 60,
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Text(
                                    'Fri, 8pm',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                  Icon(Icons.cloud, color: Colors.white),
                                  Text(
                                    '14' + "\u00B0",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: double.infinity,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('wind speed',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('4.73 m/s',
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 10,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 40,
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        Text('sunrise',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('6:10 am',
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 10,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 40,
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        Text('sunset',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('9:03 pm',
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 10,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        height: 40,
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        Text('humidity',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('72%',
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 10,
                              )),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
