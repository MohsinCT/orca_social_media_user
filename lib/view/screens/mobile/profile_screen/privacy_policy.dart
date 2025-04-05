import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  PrivacyPolicyState createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        automaticallyImplyleading: true,
        title: Text('Privacy & Policy')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://www.freeprivacypolicy.com/live/568de405-9809-48f3-9ea4-1ad2def0cdd6"),
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
