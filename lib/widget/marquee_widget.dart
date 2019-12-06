import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final Duration scrollByDuration;
  final double scrollByOffset;

  MarqueeWidget({
    @required this.itemBuilder,
    this.scrollByDuration: const Duration(seconds: 3),
    this.scrollByOffset: 50,
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController scrollController;
  FutureOr onAutoScroll;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    onAutoScroll = (_) => autoScroll();
    autoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: widget.itemBuilder,
      scrollDirection: Axis.horizontal,
      controller: scrollController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void autoScroll() {
    scrollBy(widget.scrollByOffset, duration: widget.scrollByDuration).then(onAutoScroll);
  }

  Future<void> scrollBy(double offset, {duration: const Duration(milliseconds: 1000)}) {
    if (!scrollController.hasClients) return Future.delayed(duration);
    return scrollController.animateTo(
      scrollController.offset + offset,
      duration: duration,
      curve: Curves.linear,
    );
  }
}
