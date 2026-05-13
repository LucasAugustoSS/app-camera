import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'foto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final primeiraCamera = cameras.first;

  runApp(MyApp(camera: primeiraCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detecção de Bordas',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Foto(camera: camera)
    );
  }
}