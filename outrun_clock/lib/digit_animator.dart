import 'package:flutter/cupertino.dart';

class DigitAnimator extends StatelessWidget {
  DigitAnimator({Key key, this.number, this.controller})
      : opacityIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.025,
              curve: Curves.easeIn,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(
              top: 100.0), // TODO: Fix this to handle different screen sizes
          end: const EdgeInsets.only(top: 0.0),
        ).animate(controller),
        opacityOut = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.975,
              1.0,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final String number;
  final Animation<double> controller;
  final Animation<double> opacityIn;
  final Animation<double> opacityOut;
  final Animation<EdgeInsets> padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, builder) => Container(
        child: Padding(
          padding: padding.value,
          child: Opacity(
            child: Text(number),
            opacity: 1,
            //TODO: Solve opacity for different animation lengths
            //opacityIn.value < 1.0 ? opacityIn.value : opacityOut.value,
          ),
        ),
      ),
    );
  }
}
