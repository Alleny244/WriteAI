import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:text_recognition/resultSCreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool textScanning = false;
  bool enable = false;
  XFile? imageFile;
  File? images;
  String scannedText = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scannedText = "";
    imageFile = null;
    enable = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8a9bd4),
        centerTitle: true,
        title: const Text("WriteAI"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) ...[
                  const CircularProgressIndicator(
                    color: Color(0xff8a9bd4),
                  )
                ] else ...[
                  if (!textScanning && imageFile == null)
                    Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey[300]!,
                    ),
                  if (imageFile != null) Image.file(File(imageFile!.path)),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.grey,
                              shadowColor: Colors.grey[400],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.grey,
                              shadowColor: Colors.grey[400],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  if (enable)
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff8a9bd4),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "Scan",
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Dancing Script',
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/result',
                            arguments: {'text': scannedText});
                      },
                    ),
                ]
              ],
            )),
      )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        // textScanning = true;
        imageFile = pickedImage;

        getRecognisedText(pickedImage);
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            enable = true;
          });
        });
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);

    images = File(inputImage.filePath.toString());
    print(inputImage.filePath.toString());

    // await textDetector.close();

    // for (TextBlock block in recognisedText.blocks) {
    //   for (TextLine line in block.lines) {
    //     scannedText = scannedText + line.text + "\n";
    //   }
    // }

    var dio = Dio();
    String fileName = inputImage.filePath.toString().split('/').last;
    FormData data = FormData.fromMap({
      'image': await MultipartFile.fromFile(inputImage.filePath.toString(),
          filename: fileName)
    });
    try {
      var response = await dio.post('https://ocr-wizard.p.rapidapi.com/ocr',
          data: data,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "x-rapidapi-key":
                "#######################################",
            "x-rapidapi-host": "ocr-wizard.p.rapidapi.com",
          }));
      print(response);
      if (response.statusCode == 200 &&
          (response.data['body']['fullText'] != "" &&
              response.data['body']['fullText'] != "0")) {
        scannedText = response.data['body']['fullText'];

        // print(response.data.body);
      } else if (response.statusCode != 200) {
        print("allrm");
        scannedText = "Could not load image";
        print(response);
      } else {
        scannedText = "Could not load image";
      }
    } catch (e) {
      scannedText = "Could not load image";
    }
  }

  void displayResult() {}
}
