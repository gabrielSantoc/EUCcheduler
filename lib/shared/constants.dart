import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

const MAROON = Color(0xFF862349);
const WHITE = Color(0xFFFFFFFF);
const LIGHTGRAY = Color(0xFFECECEC);
const GRAY = Color(0xFF8F8E8E);
Widget vSpacerWidth(double width) {

  return SizedBox(

    height: width,

  );
}

class SpacerClass extends StatelessWidget {
  const SpacerClass({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}


class LoadingDialog {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: MAROON,
            size: 60,
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
  }
}