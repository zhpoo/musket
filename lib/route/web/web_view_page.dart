import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musket/common/logger.dart';
import 'package:musket/route/routes.dart';
import 'package:musket/widget/title_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 需要 Route 参数为 Map，包含 'url', 'title'
class WebViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FlutterWebViewPageState();
}

class _FlutterWebViewPageState extends State<WebViewPage> {
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
    if (arguments is Map) {
      Logger.log('arguments: $arguments');
      url = arguments['url'];
      assert(url != null);
      title = arguments['title'] ?? '';
    } else {
      return buildEmptyScaffold();
    }

    return Scaffold(
      appBar: TitleBar.withBack(
        context: context,
        title: title,
        onPressBack: () => Routes.pop(context),
      ),
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
      appBar: TitleBar.withBack(context: context, title: title),
      body: isLoading ? buildLoading() : Container(),
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
  }
}
