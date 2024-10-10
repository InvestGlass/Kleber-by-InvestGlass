import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/flutter_flow_theme.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final String _link1='https://staging.investglass.com/forms/a2178090-1962-44de-af4a-a0689da63696';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CommonFunctions.showLoader(context);
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppWidgets.appBar(context, 'Sign up',leading: AppWidgets.backArrow(context)),
      body:  WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {

                },
                onPageStarted: (String url) {

                },
                onPageFinished: (String url) {
                  CommonFunctions.dismissLoader(context);
                },
                onHttpError: (HttpResponseError error) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(_link1))),
    );
  }
}
