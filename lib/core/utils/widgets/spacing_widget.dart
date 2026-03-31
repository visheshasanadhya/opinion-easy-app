import 'package:flutter/material.dart';

class VS extends StatelessWidget {
  final double height;
  const VS(this.height, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class HS extends StatelessWidget {
  final double width;
  const HS(this.width, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
