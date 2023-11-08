import 'package:flutter/material.dart';

class ResposniveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  ResposniveLayout({required this.mobileBody,required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth < 726){
          return mobileBody;
        }else{
          return desktopBody;
        }
      },
    );
  }
}