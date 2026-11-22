import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) => const CustomCard(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Content area')],
      )),
      itemCount: 4,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveBreakpoints.of(context).isDesktop
              ? 3
              : ResponsiveBreakpoints.of(context).isTablet
                  ? 2
                  : ResponsiveBreakpoints.of(context).isMobile
                      ? 1
                      : 4,
          crossAxisSpacing: 15,
          mainAxisSpacing: 12.0),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;

  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 2, color: Theme.of(context).colorScheme.onSecondary),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: Theme.of(context).cardColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
