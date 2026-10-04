import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const MoviePoster({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(url, width: width, height: height, fit: BoxFit.cover);
  }
}
