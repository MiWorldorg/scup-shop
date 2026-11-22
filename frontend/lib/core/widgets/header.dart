import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'navbar_desktop.dart';
import 'website_navbar_mobile.dart';

class Header extends StatelessWidget {
  final RxInt selectedIndex;
  const Header({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
        ? const HeaderNavbarMobile()
        : HeaderNavbarDeskTop(selectedIndex: selectedIndex);
  }
}
