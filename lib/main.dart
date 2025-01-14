import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ARセッションとオブジェクトマネージャーを宣言
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARNode mushroomNode;

  // AR設定を初期化
  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Find Mushroom'),
        ),
        body: Container(
          child: ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
        ),
      ),
    );
  }

  // ARビューが作成されたときのコールバック
  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    // AR設定を適用
    this.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/Images/triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );

    // きのこの3Dモデルを追加
    _addMushroomModel();
  }

  Future<void> _addMushroomModel() async {
    try {
      debugPrint('Loading 3D model...');
      mushroomNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "assets/pop/gltf/Cake_Pop.gltf",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, -1.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );
      arObjectManager.addNode(mushroomNode);
      debugPrint('ARNode added to the scene');
    } catch (e) {
      debugPrint('Error loading 3D model: $e');
    }
  }
}
