import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class PageManager extends ChangeNotifier{
  late Completer<XFile?> _completer;
  XFile? file;

  Future<XFile?> waitForResult() async {
    _completer = Completer<XFile?>();
    return _completer.future;
  }

  void returnData(XFile? value){
    _completer.complete(value);
    file = value;
  }

  void removeFile(){
    file = null;
  }
}