import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

EdgeInsets getResponsivePadding(BuildContext context, double screenWidth) {
  if (ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)) {
    return const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0);
  } else if (ResponsiveBreakpoints.of(context).smallerOrEqualTo(DESKTOP)) {
    return EdgeInsets.fromLTRB(
      screenWidth * 0.058,
      24.0,
      screenWidth * 0.058,
      0,
    );
  } else {
    return EdgeInsets.fromLTRB(
      screenWidth * 0.1,
      24.0,
      screenWidth * 0.1,
      0,
    );
  }
}
