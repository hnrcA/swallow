import "package:flutter/material.dart";

class LayoutController extends StatelessWidget {
  final Widget mobileLayout;
  //final Widget webLayout;
  const LayoutController({
    Key? key,
    required this.mobileLayout,
    //required this.webLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth > 938) {
          //return webLayout;
          return mobileLayout;
        }
        return mobileLayout;
      },
    );
  }
}