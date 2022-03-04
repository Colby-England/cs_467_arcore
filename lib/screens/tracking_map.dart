import 'dart:math';
import 'dart:async';

import 'package:cs_467_arcore/coordinate_transforms/lat_long.dart';
import 'package:flutter/material.dart';
import '../utilities.dart';

class TrackingMap extends StatefulWidget {
  final Satellites satData;

  const TrackingMap(this.satData, {Key? key}) : super(key: key);

  @override
  _TrackingMap createState() => _TrackingMap();
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
  late List<ARNode> nodes;
  double bearing = 0.0;
  int count = 0;
  int countTwo = 0;

  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        // first pass through place current sat position
        if (count == 0) {
          Future<double> compass = determineHeading();
          compass.then((value) {
            bearing = value;
          });

          nodes = List<ARNode>.filled(
              widget.satData.satellites.length,
              ARNode(
                  type: NodeType.webGLB,
                  uri:
                      "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb"));

          for (int i = 0; i < widget.satData.satellites.length; i++) {
            List<double> scale = transformCoords(
                polarToCart(
                    30,
                    widget.satData.satellites[i].calculatedPositions[0]!
                        .elevation,
                    widget
                        .satData.satellites[i].calculatedPositions[0]!.azimuth),
                bearing,
                1);
            loadSatellites(scale, i);
          }
          count++;
        } else {
          for (int j = 0; j < widget.satData.satellites.length; j++) {
            List<double> scale = transformCoords(
                polarToCart(
                    30,
                    widget.satData.satellites[j].calculatedPositions[countTwo]!
                        .elevation,
                    widget.satData.satellites[j].calculatedPositions[countTwo]!
                        .azimuth),
                bearing,
                1);
            nodes[j].position = Vector3(scale[0], scale[2], scale[1]);
          }
          countTwo++;
        }
      });
    });
    super.initState();
  }

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

    Future<double> compass = determineHeading();
    compass.then((value) {
      bearing = value;
    });

    return Scaffold(
        appBar: AppBar(title: const Text('Tracking Map')),
        body: Container(
            color: const Color(0xFFFFFFFF).withOpacity(1.0),
            child: Stack(children: [
              ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig: PlaneDetectionConfig.none,
                  showPlatformType: false),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () => {showPos(context)},
                                  child: const Text('Show Origin Location'))
                            ])
                      ]))
            ])));
  }

  void showPos(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Current location"),
      content: Text('Bearing: ${bearing}deg'),
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

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arLocationManager = arLocationManager;

    this.arSessionManager.onInitialize(
        showFeaturePoints: _showFeaturePoints,
        showPlanes: _showPlanes,
        customPlaneTexturePath: _planeTexturePath,
        showAnimatedGuide: _showAnimatedGuide,
        handleTaps: _handleTaps,
        showWorldOrigin: _showWorldOrigin);

    this.arObjectManager.onInitialize();
  }

  Future<void> loadSatellites(List<double> pos, int index) async {
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.3, 0.3, 0.3),
        position: Vector3(pos[0], pos[2], pos[1]),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));
    arObjectManager.addNode(newNode);
    nodes[index] = newNode;
  }

  Widget userInterface() {
    return Scaffold(
        appBar: AppBar(title: const Text('Tracking Map')),
        body: Container(
            color: const Color(0xFFFFFFFF).withOpacity(1.0),
            child: Stack(children: [
              ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig: PlaneDetectionConfig.none,
                  showPlatformType: false),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () => {showPos(context)},
                                  child: const Text('Show Origin Location'))
                            ])
                      ]))
            ])));
  }
}
