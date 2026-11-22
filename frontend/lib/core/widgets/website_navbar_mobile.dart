import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HeaderNavbarMobile extends StatelessWidget {
  const HeaderNavbarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              tooltip: 'Open menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Ionicons.menu),
            ),
          ),
          Image.asset('assets/images/SpcLogo.png', height: 54),
        ],
      ),
    );
  }
}
