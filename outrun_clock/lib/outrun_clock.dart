import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outrun_clock/digit_animator.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class OutrunClock extends StatefulWidget {
  const OutrunClock(this.model);

  final ClockModel model;

  @override
  _OutrunClockState createState() => _OutrunClockState();
}

class _OutrunClockState extends State<OutrunClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  AnimationController _controller0;
  AnimationController _controller1;
  AnimationController _controller2;
  AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller0 = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );

    _controller1 = AnimationController(
      duration: const Duration(minutes: 10),
      vsync: this,
    );

    _controller2 = AnimationController(
      duration: const Duration(minutes: 60),
      vsync: this,
    );

    _controller3 = AnimationController(
      duration: const Duration(hours: 10),
      vsync: this,
    );

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(OutrunClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _controller0.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );

      // Sync the animations to the current time.
      _controller0.forward(from: _dateTime.second.toDouble() / 60.0);
      _controller1.forward(from: _dateTime.minute.toDouble() / 10.0);
      _controller2.forward(from: _dateTime.minute.toDouble() / 60.0);
      _controller3.forward(from: _dateTime.hour.toDouble() / 10.0);

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // TODO: Just for testing
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    // Separate out all the digits
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final digit0 = minute.substring(1);
    final digit1 = minute.substring(0, 1);
    final digit2 = hour.substring(1);
    final digit3 = hour.substring(0, 1);

    // TODO: Move these
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Exo',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 10,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: [
          Positioned(
            top: -30.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: DefaultTextStyle(
                style: defaultStyle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DigitAnimator(
                      number: digit3,
                      controller: _controller3.view,
                    ),
                    DigitAnimator(
                      number: digit2,
                      controller: _controller2.view,
                    ),
                    DigitAnimator(
                      number: digit1,
                      controller: _controller1.view,
                    ),
                    DigitAnimator(
                      number: digit0,
                      controller: _controller0.view,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // TODO: Just for testing
          Text(_dateTime.second.toString()),
        ],
      ),
    );
  }
}
