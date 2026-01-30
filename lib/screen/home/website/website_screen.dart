import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // សម្រាប់ប្រើ Clipboard
import 'package:school_app/config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class NanjingWebView extends StatefulWidget {
  final String url;
  const NanjingWebView({super.key, required this.url});

  @override
  State<NanjingWebView> createState() => _NanjingWebViewState();
}

class _NanjingWebViewState extends State<NanjingWebView> {
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
      ..loadRequest(Uri.parse(widget.url.trim()));
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
          // 🔥 ប្រើ Gradient Identity របស់ NJU
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: BrandGradient.luxury),
          ),
          toolbarHeight: 75,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
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
              icon: const Icon(Icons.share_outlined, color: AppColor.lightGold, size: 20),
              onPressed: () => Share.share('សូមចូលទៅកាន់៖ ${widget.url}'),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_browser_rounded, color: AppColor.lightGold, size: 22),
              onPressed: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
            ),
            _buildMoreMenu(),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar ពណ៌មាស
            if (loadingProgress < 1.0)
              LinearProgressIndicator(
                value: loadingProgress,
                backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                color: AppColor.accentGold,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '南京大學',
          style: TextStyle(
            fontFamily: 'MaoTi',
            fontSize: 22,
            color: AppColor.lightGold, // ប្រើពណ៌មាស
            letterSpacing: 4,
          ),
        ),
        const Text(
          'NANJING UNIVERSITY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white70,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColor.lightGold),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) async {
        if (value == 'refresh') {
          controller.reload();
        } else if (value == 'copy') {
          final String? currentUrl = await controller.currentUrl();
          if (currentUrl != null) {
            await Clipboard.setData(ClipboardData(text: currentUrl));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Link copied to clipboard"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: 'refresh',
            child: Row(children: [Icon(Icons.refresh, size: 18), SizedBox(width: 10), Text('Refresh')])
        ),
        const PopupMenuItem(
            value: 'copy',
            child: Row(children: [Icon(Icons.copy, size: 18), SizedBox(width: 10), Text('Copy Link')])
        ),
      ],
    );
  }
}