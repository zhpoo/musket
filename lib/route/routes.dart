import 'package:flutter/cupertino.dart';
import 'package:musket/route/web/web_view_page.dart';

typedef PageGenerator = Widget Function(BuildContext context, RouteSettings settings);

typedef RouteGenerator = Route<T> Function<T>(RouteSettings settings);

class Routes {
  Routes._(); // no instance.

  static PageGenerator? _pageGenerator;

  static RouteGenerator? _routeGenerator;

  static set pageGenerator(PageGenerator generator) {
    _pageGenerator = generator;
  }

  static set routeGenerator(RouteGenerator generator) {
    _routeGenerator = generator;
  }

  static Widget _generatePage(BuildContext context, RouteSettings settings) {
    if (settings.name == WebViewPage.defaultRouteName) {
      return WebViewPage(arguments: settings.arguments as Map<String, dynamic>);
    }
    if (_pageGenerator != null) {
      return _pageGenerator!(context, settings);
    }
    throw 'please set PageGenerator.';
  }

  /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// //
  /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// //
  /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// //

  static Route<T> onGenerateRoute<T>(RouteSettings settings) {
    return _routeGenerator?.call(settings) ?? createCupertinoRoute<T>(settings);
  }

  static Route<T> createCupertinoRoute<T>(
    RouteSettings settings, {
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return CupertinoPageRoute<T>(
      builder: (context) => _generatePage(context, settings),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// 获取路由传递的参数，需要在 build() 方法中调用，不能在 initState() 方法中调用
  static T getArguments<T>(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as T;
  }

  /// 打开路由页面，获取需要类型的返回值
  /// 直接调用 Navigator.pushNamed() 会由系统触发 [onGenerateRoute] 方法，无法指定具体返回值类型：
  /// Unhandled Exception: type 'MaterialPageRoute<dynamic>' is not a subtype of type 'Route<String>'
  /// 此处会创建路由并指定泛型类型，规避上面的报错。
  static Future<T?> push<T>(BuildContext context, String routeName, [Object? arguments]) {
    var settings = RouteSettings(name: routeName, arguments: arguments);
    return Navigator.push<T>(context, onGenerateRoute<T>(settings));
  }

  static Future<dynamic> pushNamed(BuildContext context, String routeName, [Object? arguments]) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// 关闭路由页面
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  /// 关闭路由页面直至返回到[page]页
  static void popUntilPage(BuildContext context, String page) {
    Navigator.of(context).popUntil((route) => route.settings.name == page);
  }
}
