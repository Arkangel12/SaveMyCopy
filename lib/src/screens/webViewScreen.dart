import 'dart:async';

import 'package:flutter/material.dart';
import 'package:savemycopy/src/widgets/fadeRoute.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final url;
  WebViewScreen({Key key, this.url}) : super(key: key);

  static Route<dynamic> route(url) {
    return FadeRoute(
      widget: WebViewScreen(
        url: url,
      ),
    );
  }

  @override
  WebViewScreenState createState() {
    return new WebViewScreenState();
  }
}

class WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String urlName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red),
        title: Text('Link Viewer', style: TextStyle(color: Colors.red)),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}