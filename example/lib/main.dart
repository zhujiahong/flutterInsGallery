import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ypimage/ypimage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  var result;

  var image;

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: TextButton(
                onPressed: () async {
                  await Ypimage.presentInsImage()
                      .then((value) => {result = value});

                  setState(() {});
                },
                child: Column(
                  children: [
                    Text('sssssssss'),
                    result != null ? Image.memory(result) : Container()
                  ],
                ))),
      ),
    );
  }
}
