import 'package:flutter/material.dart';

typedef Consumer<E> = void Function(E e);

mixin DataListenable<Function> {
  @protected
  List<Function> _dataListeners;

  void addDataListener(Function listener) {
    _dataListeners ??= [];
    if (!_dataListeners.contains(listener)) {
      _dataListeners.add(listener);
    }
  }

  void removeDataListener(Function listener) {
    _dataListeners.remove(listener);
  }

  @protected
  void notifyDataListeners(Consumer<Function> consumer) {
    for (int i = _dataListeners.length - 1; i >= 0; i--) {
      consumer(_dataListeners.elementAt(i));
    }
  }
}
