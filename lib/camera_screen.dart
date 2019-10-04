import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {

  CameraDescription camera;

  CameraScreen({Key key, @required this.camera}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      //FirebaseApp.initializeApp(context);
      _controller.startImageStream(onImageStream);

      setState(() {});
    });


  }

  onImageStream(CameraImage cameraImage){
    scanBarCode(cameraImage);
  }


  scanBarCode(CameraImage image) async{

    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(),image.height.toDouble()),
        planeData: image.planes.map((currentPlane) => FirebaseVisionImagePlaneMetadata(
            bytesPerRow: currentPlane.bytesPerRow,
            height: currentPlane.height,
            width: currentPlane.width
        )).toList(),
        rotation: ImageRotation.rotation90
    );

    var visionImage = FirebaseVisionImage.fromBytes(image.planes.first.bytes, metadata);
    var options = BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.all);

    var barcodeDetector = FirebaseVision.instance.barcodeDetector(options);
    List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);
    if(barcodes.length > 0){
      _controller.stopImageStream();
      Navigator.pop(this.context,barcodes.first.rawValue);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller));
  }
}
