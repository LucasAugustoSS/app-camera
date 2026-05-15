import 'package:camera/camera.dart';
import 'package:deteccao_bordas/resultado.dart';
import 'package:flutter/material.dart';

class Foto extends StatefulWidget {
  const Foto({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<Foto> createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tirar foto')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;

                  final image = await _controller.takePicture();

                  if (!context.mounted) return;

                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => Resultado(
                        caminhoFoto: image.path
                      )
                    )
                  );
                } catch (e) {
                  print(e);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFEFEF),
                padding: const EdgeInsets.all(20), 
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 50.0,
              ),
            )
          ]
        ),
      ),
    );
  }
}