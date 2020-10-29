import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musket/common/logger.dart';
import 'package:musket/route/mixin/safe_state.dart';
import 'package:musket/route/routes.dart';
import 'package:musket/widget/cupertino_indicator.dart';
import 'package:musket/widget/title_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 需要 Route 参数为 Map，包含 'url', 'title','action'(Widget)
class WebViewPage extends StatefulWidget {
  static const defaultRouteName = '/webView';
  static String routeName = defaultRouteName;

  static Future<void> push(
    context, {
    @required String url,
    String routeName,
    String title,
    Widget action,
  }) {
    return Routes.push(context, routeName ?? WebViewPage.routeName ?? defaultRouteName, {
      'url': url,
      'title': title,
      'action': action,
    });
  }

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends SafeState<WebViewPage> {
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    var arguments = Routes.getArguments(context);
    String url;
    String title;
    Widget right;
    if (arguments is Map) {
      Logger.log('arguments: $arguments');
      url = arguments['url'];
      assert(url != null);
      title = arguments['title'] ?? '';
      right = arguments['action'] is Widget ? arguments['action'] : null;
    } else {
      return buildEmptyScaffold();
    }

    return Scaffold(
      appBar: TitleBar.withBack(text: title, right: right != null ? [right] : null),
      body: Container(
        constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
        child: IndexedStack(
          index: isLoading ? 1 : 0,
          children: <Widget>[
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (url) => setState(() {
                isLoading = false;
              }),
            ),
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
