// import 'package:flutter/material.dart';
// import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
// import 'package:webview_flutter/webview_flutter.dart';


// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({super.key});

//   @override
//   PrivacyPolicyState createState() => PrivacyPolicyState();
// }

// class PrivacyPolicyState extends State<PrivacyPolicy> {
//   late WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {},
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(
//           'https://www.freeprivacypolicy.com/live/568de405-9809-48f3-9ea4-1ad2def0cdd6'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppbar(title: Text('Privacy & Policy')),
//       body: WebViewWidget(controller: _controller),
// );
// }
// }