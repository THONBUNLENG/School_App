import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';
import '../../api/api_sever.dart';
import '../../config/app_color.dart';
import 'payment_success.dart';

class ConfirmTopUpScreen extends StatelessWidget {
  final String childName;
  final double amount;
  final String note;
  final String paymentMethod;

  const ConfirmTopUpScreen({
    super.key,
    required this.childName,
    required this.amount,
    required this.note,
    required this.paymentMethod,
  });

  // 💡 Format លេខទឹកប្រាក់ឱ្យមានក្បៀស (ឧទាហរណ៍៖ 1,000.00)
  String get formattedAmount => NumberFormat("#,##0.00").format(amount);

  Future<void> _handlePayment(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
      // Step A: Biometric Verification
      final bool canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      bool authenticated = false;

      if (canAuthenticate) {
        authenticated = await auth.authenticate(
          localizedReason: 'Please verify to confirm your payment of ¥$formattedAmount',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
            useErrorDialogs: true,
          ),
        );
      } else {
        authenticated = true;
      }

      if (!authenticated) return;

      HapticFeedback.mediumImpact();
      if (context.mounted) _showLoadingDialog(context);

      final result = await TopUpService.submitTopUp(
        amount: amount,
        method: paymentMethod,
        note: note,
      );

      if (context.mounted) Navigator.pop(context);

      if (result['success'] == true) {
        HapticFeedback.heavyImpact();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => TopUpSuccessScreen(
                amount: amount,
                paymentMethod: paymentMethod,
              ),
            ),
                (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          _showCustomErrorDialog(
            context,
            "Payment Failed",
            result['message'] ?? "Transaction declined by server.",
                () => _handlePayment(context),
          );
        }
      }

    } on PlatformException catch (e) {
      _handleAuthError(context, e.code);
    } catch (e) {
      if (context.mounted) {
        _showCustomErrorDialog(
            context,
            "Network Error",
            "Please check your internet connection and try again.",
                () => _handlePayment(context)
        );
      }
    }
  }

  // --- 💡 CUSTOM PREMIUM ERROR UI ---
  void _showCustomErrorDialog(BuildContext context, String title, String message, VoidCallback onRetry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            const Icon(Icons.cloud_off_rounded, color: Colors.redAccent, size: 60),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRetry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accentGold,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("TRY AGAIN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleAuthError(BuildContext context, String code) {
    String errorMsg = "System error. Please use another method.";
    if (code == 'NotAvailable' || code == 'NotEnrolled') {
      errorMsg = "Security not set up. Please enable Biometric or PIN in Settings.";
    } else if (code == 'LockedOut') {
      errorMsg = "Too many attempts. Please try again later.";
    }
    _showErrorSnackBar(context, errorMsg);
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RotatingLogo(
                  child: Image.asset(
                    'assets/image/logo_profile.png',
                    width: 60, height: 60,
                  ),
                ),
                const SizedBox(height: 35),
                const _AnimatedLoadingText(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(Icons.verified_user_rounded, color: AppColor.accentGold, size: 45),
                      const SizedBox(height: 15),
                      const Text('CONFIRM RECHARGE AMOUNT', style: TextStyle(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      const SizedBox(height: 10),
                      Text('¥ $formattedAmount', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColor.accentGold, letterSpacing: 1.2)),
                      const SizedBox(height: 40),
                      _buildGlassDetailsCard(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildConfirmButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
          const Expanded(child: Text('PAYMENT REVIEW', textAlign: TextAlign.center, style: TextStyle(color: AppColor.lightGold, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGlassDetailsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white.withOpacity(0.08))),
          child: Column(
            children: [
              _buildDetailRow('Recipient Profile', childName, Icons.person_rounded),
              _buildDivider(),
              _buildDetailRow('Payment Provider', paymentMethod, Icons.account_balance_wallet_rounded),
              _buildDivider(),
              _buildDetailRow('Remark', note.isEmpty ? 'NJU Wallet Recharge' : note, Icons.notes_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() => Padding(padding: const EdgeInsets.symmetric(vertical: 18), child: Container(height: 1, color: Colors.white.withOpacity(0.05)));

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColor.accentGold.withOpacity(0.12), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: AppColor.accentGold, size: 22)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16))])),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      width: double.infinity, height: 62,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFFFEE140), Color(0xFFD4AF37)]), boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))]),
      child: ElevatedButton.icon(
        onPressed: () { HapticFeedback.lightImpact(); _handlePayment(context); },
        icon: const Icon(Icons.lock_person_rounded, color: Colors.black, size: 22),
        label: const Text('CONFIRM & PAY NOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}


class _RotatingLogo extends StatefulWidget {
  final Widget child;
  const _RotatingLogo({required this.child});
  @override
  State<_RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<_RotatingLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      const SizedBox(width: 100, height: 100, child: CircularProgressIndicator(color: AppColor.accentGold, strokeWidth: 2)),
      AnimatedBuilder(animation: _controller, builder: (_, child) => Transform.rotate(angle: _controller.value * 2.0 * 3.14159, child: child), child: widget.child),
    ]);
  }
}

class _AnimatedLoadingText extends StatefulWidget {
  const _AnimatedLoadingText();

  @override
  State<_AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<_AnimatedLoadingText> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opa;
  int _currentIndex = 0;

  final List<String> _loadingTexts = [
    "Securing Transaction...",
    "Verifying Identity...",
    "Processing with NJU...",
    "Almost there...",
  ];

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000)
    )..repeat(reverse: true);

    _opa = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);

    _startTextRotation();
  }

  void _startTextRotation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (!mounted) return false;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _loadingTexts.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opa,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInQuart,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(
          _loadingTexts[_currentIndex],
          key: ValueKey<int>(_currentIndex),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            // 🔥 បន្ថែម Font របស់អ្នកនៅទីនេះ
            fontFamily: 'Gantari',
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 12,
            shadows: [
              Shadow(
                color: AppColor.accentGold,
                blurRadius: 12,
                offset: Offset(0, 0),
              )
            ],
          ),
        ),
      ),
    );
  }
}