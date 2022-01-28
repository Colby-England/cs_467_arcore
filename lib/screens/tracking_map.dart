import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:vector_math/vector_math_64.dart';

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

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            onLoadObject()
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
      content: Text(arLocationManager.currentLocation.toString()),
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
  }

}
