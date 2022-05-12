/*
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_to_text/view/scanner_util.dart';

import 'detector.dart';

class CameraPreviewScanner extends StatefulWidget {
  const CameraPreviewScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  CameraController? _camera;

  */
/*=CameraController(
    cameras[0],
    ResolutionPreset.high,
  );*/ /*

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  final TextRecognizer _recognizer = GoogleVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((callback) async {
      await _initializeCamera();
    });
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description = await ScannerUtilsWidget.getCamera(_direction);
    final CameraController cameraController = CameraController(description, ResolutionPreset.high, enableAudio: false);
    _camera = cameraController;

    await _camera!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    try {
      await _camera!.startImageStream((image) {
        if (_isDetecting) return;

        _isDetecting = true;

        ScannerUtilsWidget.detect(
          image: image,
          detectInImage: (visionImage) {
            print(visionImage);
            return _recognizer.processImage(visionImage);
          },
          imageRotation: description.sensorOrientation,
        ).then(
          (dynamic results) {
            print("------------");
            print(results.runtimeType);

            setState(() {
              _scanResults = results;
            });
          },
        ).whenComplete(() => Future.delayed(
            const Duration(
              milliseconds: 100,
            ),
            () => {_isDetecting = false}));
      });
    } catch (e) {
      print("+==> stream image ${e.toString()}");
    }

    */
/*   final CameraDescription description =
    await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
     ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera!.initialize();

    await _camera!.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
          if (_currentDetector == null) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => Future.delayed(
          Duration(
            milliseconds: 100,
          ),
              () => {_isDetecting = false}));
    });*/ /*

  }

  Future<dynamic> Function(GoogleVisionImage visionImage) _getDetectionMethod() {
    return _recognizer.processImage;
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null || _camera == null || !_camera!.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera!.value.previewSize!.height,
      _camera!.value.previewSize!.width,
    );

    // assert(_currentDetector == Detector.text);
    if (_scanResults is! VisionText) return noResultsText;
    painter = TextDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera!),
                _buildResults(),
              ],
            ),
    );
  }

  Future<void> _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera!.stopImageStream();
    await _camera!.dispose();

    setState(() {
      _camera = null;
    });

    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Vision Example'),
      ),
      body: _buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCameraDirection,
        child: _direction == CameraLensDirection.back ? const Icon(Icons.camera_front) : const Icon(Icons.camera_rear),
      ),
    );
  }

  @override
  void dispose() {
    _camera!.dispose().then((_) {
      _recognizer.close();
    });

    super.dispose();
  }
}
*/
