
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';


class MLPage extends StatefulWidget {
  final String url;
  final File imageFile;

  MLPage(this.imageFile, this.url);

  @override
  _MLPageState createState() => _MLPageState();
}

class _MLPageState extends State<MLPage> {

  File _croppedImage;
  String _text;

  @override
  void initState() {
    _croppedImage = null;
    _text = "";

  }


  _cropImage() async {

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: widget.imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop XD',
          statusBarColor: Colors.black87,
          toolbarColor: Colors.black87,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false
      ),
    );
    if (croppedFile != null) {
      _readText(croppedFile);
      setState(() {
        _croppedImage = croppedFile;
      });
    }
  }

  _readText(image) async {
    var tempText = "";

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          tempText = tempText + " " + word.text;
        }
        tempText = tempText + '\n';
      }
      tempText = tempText + '\n';
    }

    setState(() {
      _text = tempText;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network("http://192.168.0.102:5000/image/images14result.jpg"),
    );
  }
}
