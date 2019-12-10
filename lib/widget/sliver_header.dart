import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// 扩展 [SliverPersistentHeader]，支持 [snap] 属性，仿 [SliverAppBar].
/// 若[maxHeight]未指定，则会自动测量[child]高度作为[maxHeight]
class SliverHeader extends StatefulWidget {
  final Widget child;
  final double maxHeight;
  final double minHeight;
  final bool snap;
  final bool floating;
  final bool pinned;

  const SliverHeader({
    Key key,
    @required this.child,
    this.maxHeight,
    this.minHeight: 0,
    this.snap: false,
    this.pinned: false,
    this.floating: false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SliverHeaderState();
}

class _SliverHeaderState extends State<SliverHeader> with TickerProviderStateMixin {
  FloatingHeaderSnapConfiguration _snapConfiguration;
  GlobalKey sliverHeaderKey;
  double childHeight;

  void _updateSnapConfiguration() {
    if (widget.snap && widget.floating) {
      _snapConfiguration = FloatingHeaderSnapConfiguration(
        vsync: this,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _snapConfiguration = null;
    }
  }

  @override
  void initState() {
    super.initState();
    sliverHeaderKey = GlobalKey();
    _updateSnapConfiguration();
  }

  void postCalculateChildHeight() {
    SchedulerBinding.instance.addPostFrameCallback(calculateChildHeight);
  }

  @override
  void didUpdateWidget(SliverHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      postCalculateChildHeight();
    }
    if (widget.snap != oldWidget.snap || widget.floating != oldWidget.floating)
      _updateSnapConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: widget.floating,
      pinned: widget.pinned,
      delegate: SliverHeaderDelegate(
        child: widget.child,
        childKey: sliverHeaderKey,
        maxHeight: widget.maxHeight ?? childHeight ?? 0,
        minHeight: widget.minHeight ?? 0,
        snapConfiguration: _snapConfiguration,
        floating: widget.floating,
        pinned: widget.pinned,
      ),
    );
  }

  void calculateChildHeight(Duration timeStamp) {
    RenderBox renderBox = sliverHeaderKey.currentContext.findRenderObject();
    setState(() {
      childHeight = renderBox.size.height;
    });
  }
}

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Key childKey;
  final double maxHeight;
  final double minHeight;
  final bool pinned;
  final bool floating;

  const SliverHeaderDelegate({
    @required this.child,
    @required this.maxHeight,
    @required this.minHeight,
    @required this.snapConfiguration,
    this.childKey,
    this.pinned = false,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    Widget child = Material(
      child: this.child,
      elevation: overlapsContent ? 4.0 : 0,
    );
    return Stack(children: <Widget>[
      Positioned(
        key: childKey,
        child: floating ? FloatingWidget(child: child) : child,
        top: pinned ? 0 : -shrinkOffset,
      ),
    ]);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => pinned ? maxHeight : minHeight;

  @override
  final FloatingHeaderSnapConfiguration snapConfiguration;

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.childKey != childKey ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.pinned != pinned ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.snapConfiguration != snapConfiguration;
  }
}

/// [FloatingWidget]is copied from [SliverAppBar]
class FloatingWidget extends StatefulWidget {
  const FloatingWidget({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _FloatingWidgetState createState() => _FloatingWidgetState();
}

// A wrapper for the widget created by _SliverAppBarDelegate that starts and
// stops the floating app bar's snap-into-view or snap-out-of-view animation.
class _FloatingWidgetState extends State<FloatingWidget> {
  ScrollPosition _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) _position.isScrollingNotifier.removeListener(_isScrollingListener);
    _position = Scrollable.of(context)?.position;
    if (_position != null) _position.isScrollingNotifier.addListener(_isScrollingListener);
  }

  @override
  void dispose() {
    if (_position != null) _position.isScrollingNotifier.removeListener(_isScrollingListener);
    super.dispose();
  }

  RenderSliverFloatingPersistentHeader _headerRenderer() {
    return context.ancestorRenderObjectOfType(
      const TypeMatcher<RenderSliverFloatingPersistentHeader>(),
    );
  }

  void _isScrollingListener() {
    if (_position == null) return;

    // When a scroll stops, then maybe snap the appbar into view.
    // Similarly, when a scroll starts, then maybe stop the snap animation.
    final RenderSliverFloatingPersistentHeader header = _headerRenderer();
    if (_position.isScrollingNotifier.value)
      header?.maybeStopSnapAnimation(_position.userScrollDirection);
    else
      header?.maybeStartSnapAnimation(_position.userScrollDirection);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
