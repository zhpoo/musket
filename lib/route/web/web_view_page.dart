import 'package:flutter/material.dart';
import 'package:musket/common/logger.dart';
import 'package:musket/musket.dart';
import 'package:musket/route/mixin/safe_state.dart';
import 'package:musket/route/routes.dart';
import 'package:musket/widget/cupertino_indicator.dart';
import 'package:musket/widget/title_bar.dart';

/// 需要 Route 参数为 Map，包含 'url', 'title','action'(Widget)
class WebViewPage extends StatefulWidget {
  static const defaultRouteName = '/webView';
  static String routeName = defaultRouteName;

  static Future<void> push(
    context, {
    required String url,
    String? routeName,
    String? title,
    bool titleWithBack = true,
    Widget? action,
  }) {
    return Routes.push(context, routeName ?? WebViewPage.routeName, {
      'url': url,
      'title': title,
      'action': action,
      'titleWithBack': titleWithBack,
    });
  }

  final Map<String, dynamic>? arguments;

  const WebViewPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends SafeState<WebViewPage> {
  late bool isLoading;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    isLoading = true;
    initController();
  }

  void initController() {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) => setState(() => isLoading = false),
    ));

    controller.loadRequest(Uri.parse(widget.arguments?['url'] ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    Object? arguments = widget.arguments ?? Routes.getArguments(context);
    String? url;
    String title;
    Widget? right;
    bool titleWithBack;
    if (arguments != null && arguments is Map) {
      Logger.log('arguments: $arguments');
      url = arguments['url'];
      assert(url != null);
      title = arguments['title'] ?? '';
      right = arguments['action'] is Widget ? arguments['action'] : null;
      titleWithBack = arguments['titleWithBack'] ?? true;
    } else {
      return buildEmptyScaffold();
    }

    return Scaffold(
      appBar: TitleBar.text(
        text: title,
        right: right != null ? [right] : null,
        left: titleWithBack ? const BackButton() : null,
      ),
      body: Container(
        constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
        child: IndexedStack(
          index: isLoading ? 1 : 0,
          children: <Widget>[
            WebViewWidget(controller: WebViewController()),
            buildLoading(),
          ],
        ),
      ),
    );
  }

  Scaffold buildEmptyScaffold([String title = '', bool isLoading = false]) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const BackButton(), title: Text(title)),
      body: isLoading ? buildLoading() : Container(),
    );
  }

  Widget buildLoading() {
    return Center(child: CupertinoIndicator(radius: 12));
  }
}
