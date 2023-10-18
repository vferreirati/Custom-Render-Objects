import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.text,
    required this.sentAt,
    this.isLocal = true,
  });

  final String text;
  final String sentAt;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final contentWidth = width / 2;

    final color = isLocal ? Colors.blue[100] : Colors.green[100];
    const roundRadius = Radius.circular(12.0);

    return Align(
      alignment:
          isLocal ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: SizedBox(
        width: contentWidth,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              bottomLeft: roundRadius,
              bottomRight: roundRadius,
              topLeft: isLocal ? roundRadius : Radius.zero,
              topRight: !isLocal ? roundRadius : Radius.zero,
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: ChatBubbleContent(
            text: text,
            sentAt: sentAt,
          ),
        ),
      ),
    );
  }
}

class ChatBubbleContent extends LeafRenderObjectWidget {
  final String text;
  final String sentAt;

  const ChatBubbleContent({
    super.key,
    required this.text,
    required this.sentAt,
  });

  @override
  RenderObject createRenderObject(
    BuildContext context,
  ) {
    final style = DefaultTextStyle.of(context).style;

    return TimestampedChatBubbleRenderObject(
      sentAt: sentAt,
      text: text,
      textDirection: Directionality.of(context),
      sentAtStyle: style.copyWith(color: Colors.grey),
      textStyle: style,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant TimestampedChatBubbleRenderObject renderObject,
  ) {
    final style = DefaultTextStyle.of(context).style;

    renderObject.text = text;
    renderObject.textStyle = style;

    renderObject.sentAt = sentAt;
    renderObject.sentAtStyle = style.copyWith(color: Colors.grey);

    renderObject.textDirection = Directionality.of(context);
  }
}

class TimestampedChatBubbleRenderObject extends RenderBox {
  TimestampedChatBubbleRenderObject({
    required String text,
    required String sentAt,
    required TextStyle textStyle,
    required TextStyle sentAtStyle,
    required TextDirection textDirection,
  }) {
    _text = text;
    _sentAt = sentAt;
    _textDirection = textDirection;
    _sentAtStyle = sentAtStyle;
    _textStyle = textStyle;
    _textPainter = TextPainter(
      text: textTextSpan,
      textDirection: _textDirection,
    );
    _sentAtTextPainter = TextPainter(
      text: sentAtTextSpan,
      textDirection: _textDirection,
    );
  }

  late String _text;
  late String _sentAt;
  late TextDirection _textDirection;
  late TextPainter _textPainter;
  late TextPainter _sentAtTextPainter;
  late TextStyle _sentAtStyle;
  late TextStyle _textStyle;

  late bool _sentAtFitsOnLastLine;
  late double _lineHeight;
  late double _lastLineWidth;
  late double _sentAtLineWidth;
  late int _lineCount;

  set sentAt(String value) {
    if (value == _sentAt) return;

    _sentAt = value;
    _sentAtTextPainter.text = sentAtTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set sentAtStyle(TextStyle value) {
    if (value == _sentAtStyle) return;

    _sentAtStyle = value;
    _sentAtTextPainter.text = sentAtTextSpan;

    markNeedsLayout();
  }

  String get text => _text;
  set text(String value) {
    if (value == _text) return;

    _text = value;
    _textPainter.text = textTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextStyle get textStyle => _textStyle;
  set textStyle(TextStyle value) {
    if (value == _textStyle) return;

    _textStyle = value;
    _textPainter.text = textTextSpan;

    markNeedsLayout();
  }

  set textDirection(TextDirection value) {
    if (value == _textDirection) return;

    _textDirection = value;
    _textPainter.textDirection = value;
    _sentAtTextPainter.textDirection = value;

    markNeedsSemanticsUpdate();
  }

  TextSpan get textTextSpan => TextSpan(text: _text, style: _textStyle);
  TextSpan get sentAtTextSpan => TextSpan(text: _sentAt, style: _sentAtStyle);

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    config.isSemanticBoundary = true;

    config.label = '$_text, sent $_sentAt';
    config.textDirection = _textDirection;
  }

  @override
  void performLayout() {
    if (_textPainter.text?.toPlainText() == '') {
      size = Size.zero;
      return;
    }

    final maxWidth = constraints.maxWidth;
    assert(
      maxWidth > 0,
      'No available space to layout a TimestampedBubbleMessageRenderObject',
    );

    _textPainter.layout(maxWidth: maxWidth);
    final textLines = _textPainter.computeLineMetrics();

    _sentAtTextPainter.layout(maxWidth: maxWidth);
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    var longestLineWidth = 0.0;

    for (final line in textLines) {
      longestLineWidth = max(line.width, longestLineWidth);
    }

    longestLineWidth = max(longestLineWidth, _sentAtTextPainter.width);

    final messageSize = Size(longestLineWidth, _textPainter.height);

    _lastLineWidth = textLines.last.width;
    _lineCount = textLines.length;
    _lineHeight = textLines.last.height;

    final lastLineWithDate = _lastLineWidth + (_sentAtLineWidth * 1.08);
    if (textLines.length == 1) {
      _sentAtFitsOnLastLine = lastLineWithDate < maxWidth;
    } else {
      _sentAtFitsOnLastLine =
          lastLineWithDate < min(longestLineWidth, maxWidth);
    }

    late Size computedSize;
    if (!_sentAtFitsOnLastLine) {
      computedSize = Size(
        messageSize.width,
        messageSize.height + _sentAtTextPainter.height,
      );
    } else {
      if (textLines.length == 1) {
        computedSize = Size(
          lastLineWithDate,
          messageSize.height,
        );
      } else {
        computedSize = Size(
          longestLineWidth,
          messageSize.height,
        );
      }
    }

    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_textPainter.text?.toPlainText() == '') return;

    _textPainter.paint(context.canvas, offset);

    late Offset sentAtOffset;
    if (_sentAtFitsOnLastLine) {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_lineHeight * (_lineCount - 1)),
      );
    } else {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + _lineHeight * _lineCount,
      );
    }

    _sentAtTextPainter.paint(context.canvas, sentAtOffset);
  }
}
