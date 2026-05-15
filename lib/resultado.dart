import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class Resultado extends StatefulWidget {
  const Resultado({super.key, required this.caminhoFoto});

  final String caminhoFoto;

  @override
  State<Resultado> createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  String? caminhoCinza;
  String? caminhoBordas;

  String? caminhoAtual;
  String filtroAtual = 'original';

  @override
  void initState() {
    super.initState();
    caminhoAtual = widget.caminhoFoto;
    imagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: caminhoAtual != null ? Image.file(File(caminhoAtual!)) : const CircularProgressIndicator()
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'original',
                    label: Text('Original'),
                  ),
                  ButtonSegment(
                    value: 'cinza',
                    label: Text('Cinza'),
                  ),
                  ButtonSegment(
                    value: 'bordas',
                    label: Text('Bordas'),
                  ),
                ],
                selected: {filtroAtual},
                onSelectionChanged: (filtroSelecionado) {
                  setState(() {
                    filtroAtual = filtroSelecionado.first;

                    switch (filtroAtual) {
                      case 'original':
                        caminhoAtual = widget.caminhoFoto;
                        break;

                      case 'cinza':
                        caminhoAtual = caminhoCinza;
                        break;

                      case 'bordas':
                        caminhoAtual = caminhoBordas;
                        break;
                    }
                  });
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  side: const BorderSide(
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> imagens() async {
    await transformarImagem(widget.caminhoFoto, 'cinza');
    await transformarImagem(caminhoCinza!, 'bordas');
  }

  Future<void> transformarImagem(String caminhoFoto, String transformacao) async {
    final bytes = await File(caminhoFoto).readAsBytes();

    img.Image imagem = img.decodeImage(bytes)!;
    img.Image imagemTransformada;

    switch (transformacao) {
      case 'cinza':
        imagemTransformada = img.grayscale(imagem);
        break;

      case 'bordas':
        imagemTransformada = img.sobel(imagem);
        break;

      default:
        imagemTransformada = imagem;
        break;
    }

    final caminho = caminhoFoto.replaceFirst('.jpg', '_$transformacao.jpg');

    await File(caminho).writeAsBytes(img.encodeJpg(imagemTransformada));

    setState(() {
      switch (transformacao) {
        case 'cinza':
          caminhoCinza = caminho;
          break;

        case 'bordas':
          caminhoBordas = caminho;
          break;

        default:
          break;
      }
    });
  }
}