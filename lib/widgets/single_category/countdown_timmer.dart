import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimmer extends StatefulWidget {
  final DateTime dueDate;
  const CountdownTimmer({
    super.key,
    required this.dueDate,
  });

  @override
  State<CountdownTimmer> createState() => _CountdownTimmerState();
}

class _CountdownTimmerState extends State<CountdownTimmer> {
  late DateTime _dueDate;
  late Duration _remaninigTime;
  late Timer _timer;

  void _calculateRemainigTime() {
    setState(() {
      _remaninigTime = _dueDate.difference(DateTime.now());
    });
  }

  void _updateRemainigTime() {
    if (_remaninigTime.inSeconds > 0) {
      setState(() {
        _remaninigTime = _dueDate.difference(DateTime.now());
      });
    } else {
      _timer.cancel();
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "DeadLine passed";
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return "$hours h $minutes min $seconds s";
  }

  @override
  void initState() {
    super.initState();
    _dueDate = widget.dueDate;
    _calculateRemainigTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemainigTime(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final String formatterTime = _formatDuration(_remaninigTime);
    return Text(
      formatterTime,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}
