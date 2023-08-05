import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  File? image;
  ImagePicker? imagePicker;

  pickImageFromeGallery() async {
    PickedFile pickedFile =
        await imagePicker!.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    setState(() {
      image;
      perfromImageLabeling();
    });
  }

  pickImageFromeCamera() async {
    PickedFile pickedFile =
        await imagePicker!.getImage(source: ImageSource.camera);

    image = File(pickedFile.path);
    setState(() {
      image;
      perfromImageLabeling();
    });
  }

  perfromImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image!);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = '';
    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String txt = block.text!;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += "${element.text} ";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(image: DecorationImage(image: AssetImage(''))),
        child: Column(
          children: [
            const SizedBox(width: 100),
            Container(
              height: 300,
              width: 250,
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.only(left: 30, bottom: 5),
              // ignore: sort_child_properties_last
              child: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'result',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(''), fit: BoxFit.cover)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          '',
                          height: 250,
                          width: 250,
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: image != null
                              ? Image.file(
                                  image!,
                                  width: 150,
                                  height: 200,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  width: 250,
                                  height: 200,
                                  child: const Icon(
                                    Icons.camera_enhance_sharp,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
