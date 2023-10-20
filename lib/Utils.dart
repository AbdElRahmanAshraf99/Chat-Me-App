import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class AppUtils {
  static fetchColorFromHex(String s) {
    if (s == '') return Colors.white;
    if (s.contains('#'))
      return Color(int.parse(s.replaceAll('#', '0xFF')));
    else
      return Color(int.parse('0xFF' + s));
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider? imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
