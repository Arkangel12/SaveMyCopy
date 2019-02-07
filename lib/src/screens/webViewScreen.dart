import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savemycopy/src/widgets/fadeRoute.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final url;

  WebViewScreen({Key key, this.url}) : super(key: key);

  static Route<dynamic> route(url) {
    return FadeRoute(
      widget: WebViewScreen(
        url: url,
      ),
    );
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String urlName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red),
        title: Text('Link Viewer', style: TextStyle(color: Colors.red)),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
//      floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              urlName = await controller.data.currentUrl();
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Favorited $urlName")),
              );
            },
            child: const Icon(Icons.favorite),
          );
        }
        return Container();
      },
    );
  }
}
