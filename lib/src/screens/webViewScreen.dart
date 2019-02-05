import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final url;

  WebViewScreen({Key key, this.url}) : super(key: key);

  static Route<dynamic> route(url) {
    return MaterialPageRoute(
      builder: (context) => WebViewScreen(url: url),
    );
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String urlName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Pages'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      floatingActionButton: favoriteButton(),
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