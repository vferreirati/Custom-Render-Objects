import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'wave_painter.dart';

/// A widget that applies the `WavePainter` CustomPainter as a shader into its
/// child.
///
/// {@tool snippet}
///
/// This example applies the shader to the text `65%`:
///
/// ```dart
/// WaveShaderMask(
///    waveColor: Colors.blue,
///    waveOffset: 0.5,
///    wavePercentage: 0.65,
///    blendMode: BlendMode.srcATop,
///    child: Text(
///     '65%',
///     style: ...,
///   ),
/// ),
/// ```
///
/// {@end-tool}
///
/// This widget implementation is based on the [ShaderMask] widget, which also
/// uses the [RenderShaderMask] RenderObject to apply the [Shader] in the
/// painting process.
///
/// See also:
///
/// * [ShaderMask], to understand how the implementation works.
/// * [RenderShaderMask], which implements the painting of the provided shader.
class WaveShaderMask extends SingleChildRenderObjectWidget {
  const WaveShaderMask({
    super.key,
    this.blendMode = BlendMode.modulate,
    required this.waveOffset,
    required this.wavePercentage,
    required this.waveColor,
    super.child,
  });

  /// The [BlendMode] to use when applying the shader to the child.
  ///
  /// The default, [BlendMode.modulate], is useful for applying an alpha blend
  /// to the child. Other blend modes can be used to create other effects.
  final BlendMode blendMode;

  /// The offset used to shift the wave horizontally.
  ///
  /// This parameter can be used to animate the wave.
  ///
  /// Must be a value between `0.0` and `1.0`.
  final double waveOffset;

  /// The height percentage the wave should have.
  ///
  /// Must be a value between `0.0` and `1.0`.
  final double wavePercentage;

  /// The color that should be used to paint the wave.
  final Color waveColor;

  @override
  RenderShaderMask createRenderObject(BuildContext context) {
    return RenderShaderMask(
      shaderCallback: getWaveShader,
      blendMode: blendMode,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderShaderMask renderObject,
  ) {
    renderObject
      ..blendMode = blendMode
      ..shaderCallback = getWaveShader;
  }

  Shader getWaveShader(Rect bounds) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, bounds);
    final painter = WavePainter(
      waveOffset: waveOffset,
      wavePercentage: wavePercentage,
      waveColor: Colors.blue,
    );

    painter.paint(canvas, bounds.size);
    final image = recorder.endRecording().toImageSync(
          bounds.width.toInt(),
          bounds.height.toInt(),
        );

    return ImageShader(
      image,
      TileMode.repeated,
      TileMode.repeated,
      Matrix4.identity().storage,
    );
  }
}
