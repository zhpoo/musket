import 'package:flutter/material.dart';

mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  @override
  void setState([VoidCallback fn]) {
    if (!mounted) return;
    super.setState(fn ?? () {});
  }
}

abstract class SafeState<T extends StatefulWidget> extends State<T> with SafeStateMixin<T> {}
