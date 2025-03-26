// import 'package:flutter/material.dart';
// import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';

// import 'package:webview_flutter/webview_flutter.dart';

// class TermsAndConditions extends StatefulWidget {
//   const TermsAndConditions({super.key});

//   @override
//   TermsAndConditionsState createState() => TermsAndConditionsState();
// }

// class TermsAndConditionsState extends State<TermsAndConditions> {
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
//           'https://www.freeprivacypolicy.com/live/6a333114-ef2a-45ec-8dbe-c331f6e6a331'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppbar(title: Text('Terms & Conditions')),
//       body: WebViewWidget(controller: _controller),
//  );
// }
// }