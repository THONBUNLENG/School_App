import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
class ElectricityPage extends StatefulWidget {
  final String url;
  const ElectricityPage({super.key, required this.url});

  @override
  State<ElectricityPage> createState() => _NanjingWebViewState();
}

class _NanjingWebViewState extends State<ElectricityPage> {
  late final WebViewController controller;
  double loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => loadingProgress = progress / 100);
          },
          onPageStarted: (url) => setState(() => loadingProgress = 0),
          onPageFinished: (url) => setState(() => loadingProgress = 1.0),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await controller.canGoBack()) {
          controller.goBack();
        } else {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          toolbarHeight: 70,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: _buildAppTitle(),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 20),
              onPressed: () => Share.share('Please go to:៖ ${widget.url}'),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_browser, color: Colors.white, size: 22),
              onPressed: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
            ),
            _buildMoreMenu(),
          ],
        ),
        body: Column(
          children: [
            if (loadingProgress < 1.0)
              LinearProgressIndicator(
                value: loadingProgress,
                backgroundColor: Colors.white,
                color: const Color(0xFF81005B),
                minHeight: 3,
              ),
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAppTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 12),
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'EmptyRooms',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'NUJ',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),
          ],
        )
      ],
    );
  }


  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) async {
        if (value == 'refresh') {
          controller.reload();
        } else if (value == 'copy') {
          // Logic  Copy Link  Clipboard.setData
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'refresh', child: Row(children: [Icon(Icons.refresh, size: 18), SizedBox(width: 8), Text('Refresh')])),
        const PopupMenuItem(value: 'copy', child: Row(children: [Icon(Icons.copy, size: 18), SizedBox(width: 8), Text('Copy Link')])),
      ],
    );
  }
}