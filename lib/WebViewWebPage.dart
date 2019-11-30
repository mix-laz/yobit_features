import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewWebPage extends StatelessWidget {
  final String url;

  WebViewWebPage({this.url});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      hidden: false,
      appBar: AppBar(title: Text("Open Web Page URL in webview")),
    );
  }
}