import 'package:flutter/material.dart';

class MediaQueryHelper {
  final BuildContext context;

  MediaQueryHelper(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  bool get isMobile => screenWidth < 600;
  bool get isKeyboradOpen => MediaQuery.of(context).viewInsets.bottom > 0;
}
