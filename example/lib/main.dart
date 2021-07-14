import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ypimage/ypimage.dart';
import 'package:path_provider/path_provider.dart';

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

  Map result;

  var image;
  List images = [];
  List videos = [];
  List<File> imageFiles = [];

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
                  await Ypimage.presentInsImage().then((value) async {
                    result = value;
                    images = result['images'];
                    videos = result['videos'];

                    imageFiles.clear();
                    if (images.length > 0) {
                      await Future.wait(images.map((e) => imagesSave(e)));
                    }
                  });

                  setState(() {});
                },
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text('sssssssss'),
                    imageFiles.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: images.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              File image = imageFiles[index];
                              return Image.file(image);
                            })
                        : Container(),
                    videos.length > 0 ? Text(videos.toString()) : Container()
                  ],
                )))),
      ),
    );
  }

  Future imagesSave(Uint8List item) async {
    var path = await getTemporaryDirectory();
    final myImagePath = path.path + "/myimg${item.lengthInBytes}.png";
    File imageFile = File(myImagePath);
    if (!await imageFile.exists()) {
      imageFile.create(recursive: true);
    }
    imageFiles.add(await imageFile.writeAsBytes(item));
  }
}
