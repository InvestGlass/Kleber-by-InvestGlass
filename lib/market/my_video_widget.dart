import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';


class MainPage extends StatefulWidget {
  final String url;
  const MainPage(this.url,{super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WebViewControllerPlus _controler;

  @override
  void initState() {
    print('Url :: ${widget.url}');
    _controler = WebViewControllerPlus()
      ..loadFlutterAssetServer(widget.url)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controler.getWebViewHeight().then((value) {
              var height = 100.00;
              if (height != _height) {
                if (kDebugMode) {
                  print("Height is: $value");
                }
                setState(() {
                  _height = height;
                });
              }
            });
          },
        ),
      );
    super.initState();
  }

  double _height = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('webview_flutter_plus Example'),
      ),
      body: ListView(
        children: [
          Text("Height of WebviewPlus: $_height",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            height: _height,
            child: WebViewWidget(
              controller: _controler,
            ),
          ),
          const Text("End of WebviewPlus",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controler.server.close();
    super.dispose();
  }
}