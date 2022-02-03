import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:vector_math/vector_math_64.dart';

import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';

import '../device_location.dart';


class TrackingMap extends StatefulWidget {
  const TrackingMap({Key? key}) : super(key: key);
  
  @override
  _TrackingMap createState() =>_TrackingMap();
}

class _TrackingMap extends State<TrackingMap> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARLocationManager arLocationManager;
  late ARNode localObjectNode;
  final bool _showFeaturePoints = false;
  final bool _showPlanes = false;
  final bool _showWorldOrigin = true;
  final bool _showAnimatedGuide = false;
  final String _planeTexturePath = "Images/triangle.png";
  final bool _handleTaps = false;
  late double originLat;
  late double originLon;
  late double originAlt;

  Timer? _timer;

  // @override
  // void initState() {
  //   _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     setState(() {
  //       var newScale = Random().nextDouble() / 3;
  //       var newTranslationAxis = Random().nextInt(3);
  //       var newTranslationAmount = Random().nextDouble() / 3;
  //       var newTranslation = Vector3(0, 0, 0);
  //       newTranslation[newTranslationAxis] = newTranslationAmount;
  //       var newRotationAxisIndex = Random().nextInt(3);
  //       var newRotationAmount = Random().nextDouble();
  //       var newRotationAxis = Vector3(0, 0, 0);
  //       newRotationAxis[newRotationAxisIndex] = 1.0;

  //       final newTransform = Matrix4.identity();

  //       newTransform.setTranslation(newTranslation);
  //       newTransform.rotate(newRotationAxis, newRotationAmount);
  //       newTransform.scale(newScale);

  //       localObjectNode.transform = newTransform;
  //     });
  //    });
  //    super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    // get origin lat, lon, alt
    // _determinePosition();

    Future<Position> origin = determinePosition();
    origin.then((value) {
      originAlt = value.altitude;
      originLat = value.latitude;
      originLon = value.longitude;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Map')
      ),
      body: Container(
        color: const Color(0xFFFFFFFF).withOpacity(1.0),
        child: Stack(children: [
            ARView (
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.none,
              showPlatformType: false
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => {
                            showPos(context)
                          },
                          child: const Text('Load Image'))
                      ]
                    )
                  ])
            )
        ])
        
    ));
  }

  void showPos(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {Navigator.of(context).pop();},
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Current location"),
      content: Text('Lat: $originLat \n Lon: $originLon \n Alt: ${originAlt}m'),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
      this.arSessionManager = arSessionManager;
      this.arObjectManager = arObjectManager;
      this.arLocationManager = arLocationManager;

      this.arSessionManager.onInitialize(
        showFeaturePoints: _showFeaturePoints,
        showPlanes: _showPlanes,
        customPlaneTexturePath: _planeTexturePath,
        showAnimatedGuide: _showAnimatedGuide,
        handleTaps: _handleTaps,
        showWorldOrigin: _showWorldOrigin
      );

      this.arObjectManager.onInitialize();

      this
          .arLocationManager
          .startLocationUpdates()
          .then((value) => null)
          .onError((error, stackTrace) {
        switch (error.toString()) {
          case 'Location services disabled':
            {
              showAlertDialog(
                  context,
                  "Action Required",
                  "To use cloud anchor functionality, please enable your location services",
                  "Settings",
                  this.arLocationManager.openLocationServicesSettings,
                  "Cancel");
              break;
            }

          case 'Location permissions denied':
            {
              showAlertDialog(
                  context,
                  "Action Required",
                  "To use cloud anchor functionality, please allow the app to access your device's location",
                  "Retry",
                  this.arLocationManager.startLocationUpdates,
                  "Cancel");
              break;
            }

          case 'Location permissions permanently denied':
            {
              showAlertDialog(
                  context,
                  "Action Required",
                  "To use cloud anchor functionality, please allow the app to access your device's location",
                  "Settings",
                  this.arLocationManager.openAppPermissionSettings,
                  "Cancel");
              break;
            }

          default:
            {
              this.arSessionManager.onError(error.toString());
              break;
            }
        }
        this.arSessionManager.onError(error.toString());
      });
      // onLoadObject();
    }

  void showAlertDialog(BuildContext context, String title, String content, String buttonText, Function buttonFunction, String cancelButtonText) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text(cancelButtonText),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget actionButton = ElevatedButton(
      child: Text(buttonText),
      onPressed: () {
        buttonFunction();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        actionButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> onLoadObject() async {
    var newNode = ARNode(
      type: NodeType.webGLB, 
      uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
      scale: Vector3(1.0, 1.0, 1.0),
      position: Vector3(0.0, 30, 0.0),
      rotation: Vector4(1.0, 0.0, 0.0, 0.0)
    );
    arObjectManager.addNode(newNode);
    localObjectNode = newNode;
  }

  Future<void> onMoveObject() async {
    // var newNode = ARNode(
    //   type: NodeType.webGLB, 
    //   uri: "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
    //   scale: Vector3(0.2, 0.2, 0.2),
    //   position: Vector3(1.0, 0.0, 0.0),
    //   rotation: Vector4(1.0, 0.0, 0.0, 0.0)
    // );
    // arObjectManager.removeNode(localObjectNode);
    // arObjectManager.addNode(newNode);
    // localObjectNode = newNode;
    var newScale = Random().nextDouble() / 3;
    var newTranslationAxis = Random().nextInt(3);
    var newTranslationAmount = Random().nextDouble() / 3;
    var newTranslation = Vector3(0, 0, 0);
    newTranslation[newTranslationAxis] = newTranslationAmount;
    var newRotationAxisIndex = Random().nextInt(3);
    var newRotationAmount = Random().nextDouble();
    var newRotationAxis = Vector3(0, 0, 0);
    newRotationAxis[newRotationAxisIndex] = 1.0;

    final newTransform = Matrix4.identity();

    newTransform.setTranslation(newTranslation);
    newTransform.rotate(newRotationAxis, newRotationAmount);
    newTransform.scale(newScale);

    localObjectNode.transform = newTransform;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position origin = await Geolocator.getCurrentPosition();
    originAlt = origin.altitude;
    originLat = origin.latitude;
    originLon = origin.longitude;
  }
}
