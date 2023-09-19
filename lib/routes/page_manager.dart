import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageManager extends ChangeNotifier{
  late Completer<XFile?> _cameraCompleter;
  XFile? cameraFile;

  late Completer<LatLng?> _locationCompleter;
  LatLng? location;

  Future<XFile?> waitForCameraResult() async {
    _cameraCompleter = Completer<XFile?>();
    return _cameraCompleter.future;
  }

  void returnCameraData(XFile? value){
    _cameraCompleter.complete(value);
    cameraFile = value;
  }

  Future<LatLng?> waitForLocationResult() async {
    _locationCompleter = Completer<LatLng?>();
    return _locationCompleter.future;
  }

  void returnLocationData(LatLng? value){
    _locationCompleter.complete(value);
    location = value;
  }

  void removeCameraFile(){
    cameraFile = null;
  }

  void removeLocation(){
    location = null;
  }
}