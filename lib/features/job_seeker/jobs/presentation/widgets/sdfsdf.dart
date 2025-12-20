import 'package:flutter/material.dart';

// Add these extensions to your existing extension.dart file
// or create a new file: lib/core/utils/extensions/widget_extensions.dart

extension WidgetAlignmentExtension on Widget {
  /// Aligns the widget to the start (left in LTR, right in RTL)
  Widget get start => Align(
    alignment: AlignmentDirectional.centerStart,
    child: this,
  );

  /// Aligns the widget to the end (right in LTR, left in RTL)
  Widget get end => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: this,
  );

  /// Centers the widget
  Widget get center => Center(child: this);

  /// Aligns the widget to the top
  Widget get top => Align(
    alignment: Alignment.topCenter,
    child: this,
  );

  /// Aligns the widget to the bottom
  Widget get bottom => Align(
    alignment: Alignment.bottomCenter,
    child: this,
  );

  /// Aligns the widget to the top start
  Widget get topStart => Align(
    alignment: AlignmentDirectional.topStart,
    child: this,
  );

  /// Aligns the widget to the top end
  Widget get topEnd => Align(
    alignment: AlignmentDirectional.topEnd,
    child: this,
  );

  /// Aligns the widget to the bottom start
  Widget get bottomStart => Align(
    alignment: AlignmentDirectional.bottomStart,
    child: this,
  );

  /// Aligns the widget to the bottom end
  Widget get bottomEnd => Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: this,
  );
}