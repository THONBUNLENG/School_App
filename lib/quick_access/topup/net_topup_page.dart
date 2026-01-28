import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart' show AuthenticationOptions;
import 'package:school_app/config/app_color.dart';

class TopUpWallet extends StatefulWidget {
  const TopUpWallet({super.key});

  @override
  State<TopUpWallet> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpWallet> with SingleTickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();

  bool _faceIDEnabled = false;
  bool _isLoading = false;
  double _selectedAmount = 50.0;
  final TextEditingController _amountController = TextEditingController(text: '50.00');

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (_isLoading) return;

    // ១. ច្រានចោលការទូទាត់បើលេខទឹកប្រាក់មិនត្រឹមត្រូវ (Verification)
    final inputAmount = double.tryParse(_amountController.text) ?? 0;
    if (inputAmount <= 0) {
      _showErrorSnackBar("សូមបញ្ចូលទឹកប្រាក់ឱ្យបានត្រឹមត្រូវ");
      return;
    }

    // បិទ keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _rotationController.repeat();
    });

    try {
      bool authenticated = false;

      if (_faceIDEnabled) {
        final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
        final bool isSupported = await auth.isDeviceSupported();

        if (canAuthenticateWithBiometrics || isSupported) {
          authenticated = await auth.authenticate(
            localizedReason: 'សូមស្កេន FaceID/Fingerprint ដើម្បីបញ្ជាក់ការបង់ប្រាក់',
            options:  AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
              useErrorDialogs: true,
            ),
          );
        } else {
          _showErrorSnackBar("ឧបករណ៍របស់អ្នកមិនគាំទ្រការស្កេនទេ។");
          authenticated = false;
        }
      } else {
        // ប្រសិនបើមិនប្រើ Biometric គួរតែមានការសួររក App PIN (យោបល់កែលម្អ)
        authenticated = true;
      }

      if (authenticated) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) _showSuccessDialog();
      }
    } catch (e) {
      _showErrorSnackBar("បញ្ហា៖ $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _rotationController.stop();
        });
      }
    }
  }

  // ... (Widget ផ្សេងៗរក្សានៅដដែល) ...

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(fontFamily: 'Battambang')),
          backgroundColor: Colors.redAccent
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
            "Top-up Successful!\n¥${_amountController.text} has been added.",
            textAlign: TextAlign.center
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.accentGold),
              onPressed: () {
                Navigator.pop(context); // បិទ Dialog
                Navigator.pop(context); // ត្រឡប់ទៅ Home
              },
              child: const Text("Back to Home", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text('Top-up Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // (រក្សា Widget ជំនួយផ្សេងៗទៀតដូចដើម)
  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF806B9F), Colors.black.withOpacity(0.9)],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildBalanceHeader(),
                  const SizedBox(height: 30),
                  _buildMainInputCard(),
                  const SizedBox(height: 25),
                  _buildUsageHistory(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: Container(
                width: 80, height: 80,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.accentGold, width: 3),
                ),
                child: ClipOval(
                  child: Image.asset("assets/image/logo_profile.png", fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Verifying Transaction...",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Column(
      children: [
        const Text("¥ 120,567,123.68", style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)),
        const Text("Current Balance", style: TextStyle(color: Colors.white54, fontSize: 14)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.white30), borderRadius: BorderRadius.circular(20)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white70, size: 18),
              SizedBox(width: 8),
              Text("Quick Top-Up", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Amount Selection", style: TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [20, 50, 1000, 2000].map((e) => _quickBtn(e.toDouble())).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: '¥ ',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodsRow(),
          const Divider(color: Colors.white10, height: 30),
          _buildFaceIDSwitch(),
        ],
      ),
    );
  }

  Widget _buildFaceIDSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Biometric Payment (FaceID)", style: TextStyle(color: Colors.white70, fontSize: 14)),
        CupertinoSwitch(
          value: _faceIDEnabled,
          activeColor: AppColor.accentGold,
          onChanged: (val) => setState(() => _faceIDEnabled = val),
        ),
      ],
    );
  }

  Widget _buildUsageHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Usage & History", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("See All", style: TextStyle(color: AppColor.accentGold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              _buildSimpleBarChart(),
              const SizedBox(height: 16),
              _historyItem("Canteen - Lunch", "- ¥15.00", "Today, 12:30 PM"),
              _historyItem("Internet Sync", "- ¥2.00", "Yesterday, 08:00 PM"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleBarChart() {
    final List<double> data = [0.2, 0.5, 0.8, 0.4, 0.7, 0.3, 0.9];
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((h) => Container(
          width: 8, height: 60 * h,
          decoration: BoxDecoration(color: h > 0.7 ? AppColor.accentGold : Colors.white30, borderRadius: BorderRadius.circular(4)),
        )).toList(),
      ),
    );
  }

  Widget _historyItem(String title, String amt, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
          Text(amt, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsRow() {
    return Wrap(
      spacing: 10,
      children: [
        _miniIcon(Icons.wechat, "WeChat"),
        _miniIcon(Icons.payment, "Alipay"),
        _miniIcon(Icons.account_balance, "ICBC"),
      ],
    );
  }

  Widget _miniIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white54, size: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _quickBtn(double amount) {
    bool isSelected = _selectedAmount == amount;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedAmount = amount;
        _amountController.text = amount.toStringAsFixed(2);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.accentGold.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppColor.accentGold : Colors.white12),
        ),
        child: Text("¥${amount.toInt()}", style: TextStyle(color: isSelected ? AppColor.accentGold : Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.accentGold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              disabledBackgroundColor: Colors.grey[300]
          ),
          child: const Text("Confirm & Top-Up", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}