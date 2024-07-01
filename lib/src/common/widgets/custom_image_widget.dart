import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget(
    this.imageUrl, {
    super.key,
    this.size,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final Size? size;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: size?.width,
      height: size?.height,
      imageUrl: imageUrl,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: const Duration(milliseconds: 500),
      imageBuilder: (context, imageProvider) => Container(
        width: size?.width,
        height: size?.height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: shape,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
