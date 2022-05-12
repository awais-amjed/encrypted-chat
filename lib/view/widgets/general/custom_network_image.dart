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
    if (url != null) {
      if (url!.contains('assets/images/saved/')) {
        return Image.asset(
          url!,
          height: height,
          width: width,
          fit: fit,
        );
      }
    }

    return url != null
        ? Image.network(
            url ?? '',
            height: height,
            width: width,
            fit: fit,
          )
        : Image.asset(
            'assets/images/logo.png',
            height: height,
            width: width,
            fit: fit,
          );
  }
}
