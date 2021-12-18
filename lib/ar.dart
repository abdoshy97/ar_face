import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
class ArTest extends StatefulWidget {


  @override
  _ArTestState createState() => _ArTestState();
}

class _ArTestState extends State<ArTest> {
  ArCoreFaceController arcorecont;
  final GlobalKey _globalKey = GlobalKey();
  String screenshotButtonText = 'Save screenshot';
  ScreenshotController screenshotController = ScreenshotController();

  whenArCoreVeiwCreated(ArCoreFaceController faceController)
  {
    arcorecont =faceController;
    lodemesh();
  }
  lodemesh() async{
  final ByteData texttrueBytes= await rootBundle.load('assets/Face_Mask_Template.png');
  arcorecont.loadMesh(textureBytes: texttrueBytes.buffer.asUint8List(),
  skin3DModelFilename: "fox_face_sfb"
  );
}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    arcorecont.dispose();
  }
  String firstButtonText = 'Take photo';
  String albumName = 'Media';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oguol'),
        centerTitle: true,
      ),
      body:Stack(
        children: [
          ArCoreFaceView(
            onArCoreViewCreated: whenArCoreVeiwCreated,
            enableAugmentedFaces: true,
            key: _globalKey,


          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
              Padding(padding: EdgeInsets.only(left: 28.0 , right: 28.0),
              child: Expanded(
                        child: TextButton(onPressed:  () {
                          screenshotController
                              .capture(delay: Duration(milliseconds: 10))
                              .then((capturedImage) async {
                            ShowCapturedWidget(context, capturedImage);
                          }).catchError((onError) {
                            print(onError);
                          });
                        }, child:
                         Text(screenshotButtonText),
                            ),
              ),

              ),
                  ElevatedButton(
                    child: Text(
                      'Capture An Invisible Widget',
                    ),
                    onPressed: () {
                      var container = Container(
                          padding: const EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent, width: 5.0),
                            color: Colors.redAccent,
                          ),
                          child: Text(
                            "This is an invisible widget",
                            style: Theme.of(context).textTheme.headline6,
                          ));
                      screenshotController
                          .captureFromWidget(
                          InheritedTheme.captureAll(
                              context, Material(child: container)),
                          delay: Duration(seconds: 1))
                          .then((capturedImage) {
                        ShowCapturedWidget(context, capturedImage);
                      });
                    },
                  ),

                ],
              ),
            ),
          )
        ],
      )

    );

  }
  // void _takePhoto() async {
  //   ImagePicker()
  //       .getImage(source: ImageSource.camera)
  //       .then((PickedFile recordedImage) {
  //     if (recordedImage != null && recordedImage.path != null) {
  //       setState(() {
  //         firstButtonText = 'saving in progress...';
  //       });
  //
  //       GallerySaver.saveImage(recordedImage.path, albumName: albumName)
  //           .then((bool success) {
  //         setState(() {
  //           firstButtonText = 'image saved!';
  //         });
  //       });
  //     }
  //   });
  // }
  // Future<void> _saveScreenshot() async {
  //   setState(() {
  //     screenshotButtonText = 'saving in progress...';
  //   });
  //   try {
  //     //extract bytes
  //     final RenderRepaintBoundary boundary =
  //     _globalKey.currentContext.findRenderObject();
  //     final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     final ByteData byteData =
  //     await image.toByteData(format: ui.ImageByteFormat.png);
  //     final Uint8List pngBytes = byteData.buffer.asUint8List();
  //
  //     //create file
  //     final String dir = (await getApplicationDocumentsDirectory()).path;
  //     final String fullPath = '$dir/${DateTime.now().millisecond}.png';
  //     File capturedFile = File(fullPath);
  //     await capturedFile.writeAsBytes(pngBytes);
  //     print(capturedFile.path);
  //
  //     await GallerySaver.saveImage(capturedFile.path).then((value) {
  //       setState(() {
  //         screenshotButtonText = 'screenshot saved!';
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
}

