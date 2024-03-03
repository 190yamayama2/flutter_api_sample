
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_api_sample/ui/widget_keys.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({required Key key, required this.urlString}) : super(key: key);
  final String urlString;

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {

          },
          onPageFinished: (String url) {

          },
          onWebResourceError: (WebResourceError error) {

          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(widget.urlString)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlString));

    return Scaffold(
      appBar: AppBar(
        title: const Text('記事詳細'),
        leading: IconButton(
          key: const Key(WidgetKey.KEY_WEB_APP_BAR_ICON_BUTTON),
          icon: const Icon(
            Icons.arrow_back,
            key: Key(WidgetKey.KEY_WEB_APP_BAR_ICON),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebViewWidget(controller: controller);
      }),
      bottomNavigationBar: BottomAppBar(
        child: FutureBuilder<WebViewController>(
            future: _controller.future,
            builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
              return Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (await controller.canGoBack()) {
                          controller.goBack();
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (await controller.canGoForward()) {
                          controller.goForward();
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.reload();
                      },
                      icon: const Icon(Icons.autorenew),
                    ),
                  ],
              );
            }
        ),
      ),
    );
  }

}
