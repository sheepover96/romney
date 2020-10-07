import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';

import 'package:romney/global/cameras.dart' as gCamera;
import 'package:romney/ui/pages/words/addByKeyboard.dart' as wordAddByKeyboard;
import 'package:romney/viewmodels/words/add.dart';

class AddByCamera extends StatefulWidget {
  @override
  _AddByCameraState createState() => _AddByCameraState();
}

class _AddByCameraState extends State<AddByCamera> {
  final platform = const MethodChannel('dictionary_search');
  CameraController controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(gCamera.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> detectTextInImage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        builder: (context, snapshot) {
          return CameraPreview(controller);
          // if (snapshot.connectionState == ConnectionState.done) {
          //   return CameraPreview(controller);
          // } else {
          //   return Center(child: CircularProgressIndicator());
          // }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            final tookImagePath = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await controller.takePicture(tookImagePath);

            File croppedFile = await ImageCropper.cropImage(
              sourcePath: tookImagePath,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
              androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: Colors.deepOrange,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              // iosUiSettings: IOSUiSettings(
              //   minimumAspectRatio: 1.0,
              // )
            );

            final croppedImagePath = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await croppedFile.copy(croppedImagePath);

            await ImageGallerySaver.saveImage(croppedFile.readAsBytesSync());

            try {
              // await platform.invokeMethod(
              //     'searchDictionary', <String, dynamic>{"queryWord": "test"});
              final detectedText = await platform.invokeMethod(
                  'detectTextInImage',
                  <String, dynamic>{"imagePath": croppedImagePath});
              final newWord = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<WordAddViewModel>.value(
                          value: WordAddViewModel(word: detectedText),
                          child: wordAddByKeyboard.AddByKeyboard()),
                ),
              );
              Navigator.of(context).pop(newWord);
            } on PlatformException catch (e) {
              print(e);
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    );
    // return AspectRatio(
    //     aspectRatio: controller.value.aspectRatio,
    //     child: CameraPreview(controller));
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final File image;
  final String text;

  const DisplayPictureScreen({Key key, this.image, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Display the Picture')),
        body: Column(
          children: [Image.file(this.image), Text(this.text)],
        ));
  }
}

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
