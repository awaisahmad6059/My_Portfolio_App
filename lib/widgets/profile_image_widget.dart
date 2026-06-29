import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:aak/core/constants/app_colors.dart';
import 'package:aak/core/constants/app_dimensions.dart';

class AnimatedProfileImage extends StatefulWidget {
  final String imageAsset;
  final double height;
  final String heroTag;
  final Gradient? shaderMaskGradient;
  final Uint8List? customImageBytes;

  const AnimatedProfileImage({
    super.key,
    required this.imageAsset,
    this.height = 400,
    required this.heroTag,
    this.shaderMaskGradient,
    this.customImageBytes,
  });

  @override
  State<AnimatedProfileImage> createState() => _AnimatedProfileImageState();
}

class _AnimatedProfileImageState extends State<AnimatedProfileImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _floatAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.15, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContent = ClipRRect(
      borderRadius:
          const BorderRadius.all(Radius.circular(AppDimens.radiusSmall)),
      child: widget.customImageBytes != null
          ? Image.memory(
              widget.customImageBytes!,
              height: widget.height,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.asset(
              widget.imageAsset,
              height: widget.height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
    );

    if (widget.shaderMaskGradient != null) {
      imageContent = ShaderMask(
        shaderCallback: (rect) =>
            widget.shaderMaskGradient!.createShader(rect),
        blendMode: BlendMode.dstIn,
        child: imageContent,
      );
    }

    return Hero(
      tag: widget.heroTag,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.radiusSmall)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowColor
                            .withValues(alpha: _glowAnimation.value),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
        child: imageContent,
      ),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final String imageAsset;
  final double height;
  final Gradient? shaderMaskGradient;
  final Uint8List? customImageBytes;

  const ProfileImageWidget({
    super.key,
    required this.imageAsset,
    this.height = 400,
    this.shaderMaskGradient,
    this.customImageBytes,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = customImageBytes != null
        ? Image.memory(
            customImageBytes!,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.asset(
            imageAsset,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
          );

    if (shaderMaskGradient != null) {
      image = ShaderMask(
        shaderCallback: (rect) => shaderMaskGradient!.createShader(rect),
        blendMode: BlendMode.dstIn,
        child: image,
      );
    }

    return image;
  }
}
