import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  final double w;

  const HorizontalSpace({Key? key, required this.w}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: w);
  }
}

class VerticalSpace extends StatelessWidget {
  final double h;

  const VerticalSpace({Key? key, required this.h}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(height: h);
  }
}
