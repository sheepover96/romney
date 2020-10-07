import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

class WordAddByCameraViewModel extends ChangeNotifier {
  static const platform = const MethodChannel('dictionary_search');
  List<CameraDescription> cameras;
  CameraController controller;

  WordAddByCameraViewModel() {
    controller = CameraController(cameras[0], ResolutionPreset.medium);
  }
}
