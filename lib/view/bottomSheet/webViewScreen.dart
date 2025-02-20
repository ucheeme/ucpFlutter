
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/view/bottomSheet/makeSavingsDraggableBottomSheet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  String url;

  WebViewScreen({super.key, required this.url,});
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var  controller = WebViewController();
  bool isLoading = true;
  _initWebViewController(){
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
              //print("progress $progress");
              if(progress==100){
                setState(() {
                  isLoading= false;
                });
              }
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onUrlChange: (UrlChange value){
              if(value.url!.contains("&reference=")){
               Get.back();
               showSuccessAlert(context);
              }
              print("value ${value.url}");
            }
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void initState() {
    _initWebViewController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: WebViewWidget(
            controller: controller
        ),
      ),
    );
  }
}