import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:saf_worker/screens/dump_map.dart';

import '../utils/utility.dart';

class SubmitReport extends StatefulWidget {
  final snap;
  const SubmitReport({super.key, required this.snap});

  @override
  State<SubmitReport> createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport> {
  Uint8List? _savedImage;
  bool tookPictures = false;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  Location location = Location();
  double? lon, lat;
  final ImageLabeler labeler = GoogleVision.instance.imageLabeler(
    ImageLabelerOptions(confidenceThreshold: 0.75),
  );
  late List<ImageLabel> labels;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _takePictures() async {
    getUserLocationData();
    Uint8List file = await pickImage(ImageSource.camera);
    setState(() {
      tookPictures = true;
      _savedImage = file;
    });
  }

  getImageData() async {
    GoogleVisionImage visionImage =
        GoogleVisionImage.fromFile(File.fromRawPath(_savedImage!));

    labels = await labeler.processImage(visionImage);

    
  }

  Future<void> getUserLocationData() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print(_locationData.toString());
    showMap();
  }

  showMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          snap: widget.snap,
          lati: _locationData.latitude!.toDouble(),
          long: _locationData.longitude!.toDouble(),
        ),
      ),
    );
  }

  //learning code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Task Report'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 70,
            child: FloatingActionButton(
              onPressed: () {
                getUserLocationData();
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Container(
                color: Colors.blue,
                child: const Text('Map It!'),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          tookPictures == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _takePictures,
                      child: Container(
                        height: 250,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 0, 166, 255)),
                            child: const Center(
                                child: Text(
                              'Click Me to take Pictures',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Container(
                    height: 300,
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(width: 1, color: Colors.blue),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(_savedImage!),
                        )),
                  ),
                ),
          SizedBox(
            height: 20,
          ),
          TextButton(onPressed: () {}, child: Text('Submit'))
        ],
      ),
    );
  }
}
