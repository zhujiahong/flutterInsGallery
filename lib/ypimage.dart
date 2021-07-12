import 'dart:async';

import 'package:flutter/services.dart';

class Ypimage {
  static const MethodChannel _channel = const MethodChannel('ypimage');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> presentInsImage() async {
    return await _channel.invokeMethod('presentInsImage');
  }
}
