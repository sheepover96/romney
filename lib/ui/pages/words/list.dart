import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// import 'package:tutorial/database/database.dart' as db;
// import 'package:tutorial/pages/words/add.dart' as wordAdd;
// import 'package:tutorial/pages/words/detail.dart' as wordDetail;
// import 'package:tutorial/pages/words/newDialog.dart' as wordDialog;
import 'package:romney/ui/pages/words/listItem.dart' as wordItem;
import 'package:romney/ui/pages/words/addByKeyboard.dart' as wordAddByKeyboard;
import 'package:romney/ui/pages/words/addByCamera.dart' as wordAddByCamera;
import 'package:romney/viewmodels/words/add.dart';
import 'package:romney/viewmodels/words/list.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/viewmodels/words/listItem.dart';

enum WordAddOptions {
  AddByKeyboard,
  AddByCamera,
  AddByPhoto,
}

class WordList extends StatelessWidget {
  final platform = const MethodChannel('dictionary_search');

  @override
  Widget build(BuildContext context) {
    final wordModel = context.watch<WordViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Example title')),
      body: FutureBuilder(
          future: wordModel.fetchWords(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListView.builder(
                itemCount: wordModel.getList().length,
                itemBuilder: (context, index) {
                  return _buildItem(wordModel.getOne(index));
                  // return _buildItem(wordList[index]['word']);
                });
            // return _buildItemList();
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Container(
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.orangeAccent,
        // Icon(Icons.add),
        onPressed: () async {
          _openDialog(context);
        },
      ),
    );
  }

  Widget _buildItem(Word word) {
    return ChangeNotifierProvider<WordListItemViewModel>.value(
        value: WordListItemViewModel(word: word),
        child: wordItem.ListItem(word: word));
  }

  Route _createAddByKeyboardRoute() {
    return PageRouteBuilder(
      // pageBuilder: (context, animation, secondaryAnimation) => MyForm(),
      pageBuilder: (context, animation, secondaryAnimation) =>
          wordAddByKeyboard.AddByKeyboard(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.8);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: ChangeNotifierProvider<WordAddViewModel>.value(
              value: WordAddViewModel(), child: child),
        );
      },
      fullscreenDialog: true,
    );
  }

  Route _createAddByCameraRoute() {
    return PageRouteBuilder(
      // pageBuilder: (context, animation, secondaryAnimation) => MyForm(),
      pageBuilder: (context, animation, secondaryAnimation) =>
          wordAddByCamera.AddByCamera(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.8);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      fullscreenDialog: true,
    );
  }

  void _createAddByPhotoRoute() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // return PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) =>
    //       wordAddByCamera.AddByCamera(),
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     var begin = Offset(0.0, 0.8);
    //     var end = Offset.zero;
    //     var tween = Tween(begin: begin, end: end);
    //     var offsetAnimation = animation.drive(tween);
    //     return SlideTransition(
    //       position: offsetAnimation,
    //       child: child,
    //     );
    //   },
    //   fullscreenDialog: true,
    // );
  }

  void _openDialog(BuildContext context) async {
    final wordModel = context.read<WordViewModel>();
    switch (await showDialog<WordAddOptions>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Center(child: Text("単語の追加")),
              children: <Widget>[
                SimpleDialogOption(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.create, size: 40.0),
                              Text("入力")
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(
                                context, WordAddOptions.AddByKeyboard);
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo_camera, size: 40.0),
                              Text("写真")
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context, WordAddOptions.AddByCamera);
                            print("camera");
                          },
                        ),
                        GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.photo, size: 40.0),
                                Text("画像")
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context, WordAddOptions.AddByPhoto);
                              print("image");
                            }),
                        // Icon(Icons.photo),
                        // SizedBox(width: 12),
                        // Text("tesutossu")
                      ]),
                ),
              ],
            ))) {
      case WordAddOptions.AddByKeyboard:
        final newWord =
            await Navigator.of(context).push(_createAddByKeyboardRoute());
        if (newWord != null) {
          wordModel.addWord(newWord);
        }
        break;
      case WordAddOptions.AddByCamera:
        final newWord =
            await Navigator.of(context).push(_createAddByCameraRoute());
        if (newWord != null) {
          wordModel.addWord(newWord);
        }
        break;
      case WordAddOptions.AddByPhoto:
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
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
          final detectedText = await platform.invokeMethod('detectTextInImage',
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
          if (newWord != null) {
            wordModel.addWord(newWord);
          }
        } on PlatformException catch (e) {
          print(e);
        }
        // final newWord =
        //     await Navigator.of(context).push(_createAddByPhotoRoute());
        // if (newWord != null) {
        //   wordModel.addWord(newWord);
        // }
        break;
    }
  }
}
