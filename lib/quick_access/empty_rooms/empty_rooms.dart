import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // សម្រាប់ Clipboard
import 'package:school_app/config/app_color.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class EmptyRoomsPage extends StatefulWidget {
  final String url;
  const EmptyRoomsPage({super.key, required this.url});

  @override
  State<EmptyRoomsPage> createState() => _NanjingWebViewState();
}

class _NanjingWebViewState extends State<EmptyRoomsPage> {
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
          // --- ប្រើ Gradient ពណ៌ស្វាយដិត Identity របស់ NJU ---
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: BrandGradient.luxury,
            ),
          ),
          toolbarHeight: 70,
          elevation: 0,
          centerTitle: true,
          // --- ប្តូរពណ៌ Icon មកជាពណ៌មាសស្រាល ---
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
              onPressed: () => Share.share('NJU Empty Rooms: ${widget.url}'),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_browser, color: AppColor.lightGold, size: 22),
              onPressed: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
            ),
            _buildMoreMenu(),
          ],
        ),
        body: Column(
          children: [
            // --- ប្តូរពណ៌ Progress Bar មកជាពណ៌មាស ---
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
          'EMPTY ROOMS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.lightGold, // ពណ៌មាស Premium
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'NANJING UNIVERSITY',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColor.lightGold),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        if (value == 'refresh') {
          controller.reload();
        } else if (value == 'copy') {
          final url = await controller.currentUrl() ?? widget.url;
          await Clipboard.setData(ClipboardData(text: url));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Link copied to clipboard"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'refresh',
          child: Row(children: [Icon(Icons.refresh, size: 18), SizedBox(width: 10), Text('Refresh')]),
        ),
        const PopupMenuItem(
          value: 'copy',
          child: Row(children: [Icon(Icons.copy, size: 18), SizedBox(width: 10), Text('Copy Link')]),
        ),
      ],
    );
  }
}