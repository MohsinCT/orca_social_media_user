import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  TermsAndConditionsState createState() => TermsAndConditionsState();
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        automaticallyImplyleading: true,
        title: Text('Terms & Conditions')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://www.freeprivacypolicy.com/live/d3aefb12-7969-4d23-99f4-84bd3af08b46"),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          transparentBackground: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          debugPrint("Loading: $url");
        },
        onLoadStop: (controller, url) {
          debugPrint("Finished loading: $url");
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var url = navigationAction.request.url.toString();
          if (url.startsWith('https://www.youtube.com/')) {
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onReceivedError: (controller, request, error) {
          debugPrint("Error: ${error.description}");
        },
      ),
    );
  }
}
