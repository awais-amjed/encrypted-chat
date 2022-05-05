import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    Key? key,
    this.url,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);

  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      placeholder: (context, url) => const SizedBox(),
      errorWidget: (context, url, error) =>
          //TODO Add placeholder
          Image.asset('assets/images/logo.png'),
      height: height,
      width: width,
      fit: fit,
    );
  }
}