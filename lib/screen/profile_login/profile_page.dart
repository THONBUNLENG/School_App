import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/change_notifier.dart';
import 'package:school_app/screen/home/home_screen/main_holder.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/home_profile_screen.dart';
import 'package:school_app/screen/profile_login/qr_login.dart';
import 'package:school_app/screen/profile_login/wechat_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_sms.dart';


class UnifiedLoginScreen extends StatefulWidget {
  const UnifiedLoginScreen({super.key});

  @override
  State<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
}

class _UnifiedLoginScreenState extends State<UnifiedLoginScreen> {
  // --- Controllers ---
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();

  // --- UI & Logic State ---
  int _currentTab = 0;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _currentCaptcha = "";
  int _secondsRemaining = 0;
  Timer? _timer;

  // --- Validation States ---
  bool _userErr = false, _passErr = false, _capErr = false, _phoneErr = false, _smsErr = false;

  final String _passSubHint = "Please enter your password";

  @override
  void initState() {
    super.initState();
    _generateRandomCaptcha();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  // --- Core Logic ---

  void _generateRandomCaptcha() {
    const chars = 'abcdefghijkmnpqrstuvwxyz23456789';
    final random = Random();
    _currentCaptcha = String.fromCharCodes(
        Iterable.generate(4, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    if (mounted) {
      setState(() {
        _captchaController.clear();
        _capErr = false;
      });
    }
  }

  void _sendSmsCode() async {
    String cleanPhone = _phoneController.text.replaceAll(' ', '');

    if (cleanPhone.length < 9) {
      setState(() => _phoneErr = true);
      _showError("Please enter a valid phone number");
      return;
    }

    if (cleanPhone == "011820595999") {
      const String testCode = "0406";
      _triggerLongVibration();
      _showLocalNotification("Verification Code: $testCode");

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _smsController.text = testCode;
            _smsErr = false;
          });
          HapticFeedback.heavyImpact();
        }
      });
    } else {
      final result = await SmsService.sendOtp(cleanPhone);
      if (result['success']) {
        _showLocalNotification(result['message']);
      } else {
        _showError(result['message']);
        return;
      }
    }

    _timer?.cancel();
    setState(() {
      _phoneErr = false;
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

// Triple Pulse Vibration Helper
  void _triggerLongVibration() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

// Show a simple SnackBar notification
  void _showLocalNotification(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

// Calculate password strength (0.0 to 1.0)
  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;
    if (password.length >= 8) strength += 0.4;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;

    return strength.clamp(0.0, 1.0); // ensure within bounds
  }

// Get color based on password strength
  Color _getStrengthColor(double strength) {
    if (strength <= 0.4) return Colors.redAccent;
    if (strength <= 0.7) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

// Main login handler
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final user = _usernameController.text.trim();
    final pass = _passwordController.text;
    final cleanPhone = _phoneController.text.replaceAll(' ', '');
    final smsCode = _smsController.text.trim();

    // --- Validation ---
    setState(() {
      if (_currentTab == 0) {
        _userErr = user.isEmpty;
        _passErr = pass.isEmpty || pass.length < 8;
        _capErr = _captchaController.text.trim().toLowerCase() != _currentCaptcha.toLowerCase();
      } else {
        _phoneErr = cleanPhone.length < 9;
        _smsErr = smsCode.isEmpty;
      }
    });

    if (_userErr || _passErr || (_currentTab == 0 && _capErr) || _phoneErr || _smsErr) {
      if (_capErr && _currentTab == 0) {
        _showError("Captcha Incorrect");
        _generateRandomCaptcha();
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      String result;

      if (_currentTab == 0) {

        result = (user == "admin" && pass == "@Bunleng520") ? "success" : "Invalid username or password";
      } else {
        // SMS login via service
        result = await SmsService.verifyOtp(cleanPhone, smsCode);
      }

      if (!mounted) return;

      if (result == "success") {
        _onLoginSuccess();
      } else {
        _showError(result);
        if (_currentTab == 0) _generateRandomCaptcha();
      }
    } catch (e) {
      _showError("Connection failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

// Show error SnackBar
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _onLoginSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    // 💡 រក្សាទុកស្ថានភាព Login ក្នុង SharedPreferences
    await prefs.setBool('isLoggedIn', true);

    if (!mounted) return;

    // រុញទៅកាន់ MainHolder និងលុបស្គ្រីន Login ចោល (ការពារកុំឱ្យ Back មកវិញបាន)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainHolder()),
          (route) => false,
    );
  }




  // --- UI Section ---
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager?>(context)?.isDarkMode ?? false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/background_login.png',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: AppColor.accentGold),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: isDark ? Colors.black.withOpacity(0.75) : Colors.black.withOpacity(0.4),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildTabs(),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.12) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _currentTab == 0
                            ? _buildAccountForm(isDark)
                            : _buildSmsForm(isDark),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildLoginButton(),
                    const SizedBox(height: 15),
                    _buildBottomLinks(isDark),
                    const SizedBox(height: 40),
                    _buildSocialLogin(isDark),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/image/logo_school.png',
        height: 50,
        color: AppColor.lightGold,
        errorBuilder: (c, e, s) => const Icon(Icons.school, color: AppColor.lightGold, size: 45),
      ),
      const SizedBox(width: 15),


      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "南京大学",
            style: TextStyle(
              color: AppColor.lightGold,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'MaoTi',
              letterSpacing: 2,
            ),
          ),
          Text(
            "NANJING UNIVERSITY",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 30,
        width: 1.5,
        color: Colors.white24,
      ),

      const Text(
        "统一身份认证\nUNIFIED LOGIN",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    ],
  );

  Widget _buildTabs() => Row(
    children: [
      _tabItem("Account Login", 0),
      const SizedBox(width: 30),
      _tabItem("SMS Code", 1),
    ],
  );

  Widget _tabItem(String title, int index) {
    bool active = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : Colors.white60,
              fontSize: 15,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: active ? 20 : 0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.accentGold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      )
          : const Text(
        "Login",
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget _buildBottomLinks(bool isDark) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextButton(
          onPressed: () {},
          child: Text(
            "Online Help",
            style: TextStyle(color: isDark ? Colors.white54 : Colors.white70, fontSize: 12),
          )),
      TextButton(
          onPressed: () {},
          child: Text(
            "Forgot Password",
            style: TextStyle(color: isDark ? Colors.white54 : Colors.white70, fontSize: 12),
          )),
    ],
  );

  Widget _buildSocialLogin(bool isDark) => Column(
    children: [
      Row(
        children: const [
          Expanded(child: Divider(color: Colors.white24)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Other Login", style: TextStyle(color: Colors.white60, fontSize: 11)),
          ),
          Expanded(child: Divider(color: Colors.white24)),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialIcon(Icons.wechat, "WeChat", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const WeChatLoginScreen()),
            );
          }),
          const SizedBox(width: 40),
          _socialIcon(Icons.qr_code_scanner, "QR Login", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const QRCodeScreen()),
            );
          }),
        ],
      ),
    ],
  );

  Widget _socialIcon(IconData icon, String label, VoidCallback tap) => InkWell(
    onTap: tap,
    child: Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
      ],
    ),
  );

  Widget _buildAccountForm(bool isDark) {
    double strength = _calculatePasswordStrength(_passwordController.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildField(
          controller: _usernameController,
          icon: Icons.person_outline,
          hint: "Username",
          subHint: "Please enter your username",
          showError: _userErr,
          isDark: isDark,
        ),
        Divider(
          height: 1,
          color: isDark ? Colors.white10 : Colors.grey[200],
          indent: 50,
        ),
        _buildField(
          controller: _passwordController,
          icon: Icons.lock_outline,
          hint: "Password",
          subHint: _passSubHint,
          showError: _passErr,
          isDark: isDark,
          isPassword: !_isPasswordVisible,
          onChanged: (v) => setState(() {}),
          onSubmitted: (v) => _handleLogin(),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: isDark ? Colors.white70 : Colors.grey,
            ),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
        if (_passwordController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: strength,
                  backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor(strength)),
                  minHeight: 3,
                ),
                const SizedBox(height: 4),
                Text(
                  strength <= 0.4 ? "Weak" : strength <= 0.7 ? "Medium" : "Strong",
                  style: TextStyle(
                      color: _getStrengthColor(strength), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        Divider(
          height: 1,
          color: isDark ? Colors.white10 : Colors.grey[200],
          indent: 50,
        ),
        _buildCaptchaField(isDark),
      ],
    );
  }

  Widget _buildSmsForm(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildField(
          controller: _phoneController,
          icon: Icons.phone_android,
          hint: "Mobile Number",
          subHint: "Please enter a valid phone number",
          showError: _phoneErr,
          isDark: isDark,
          keyboardType: TextInputType.phone,
        ),
        Divider(
          height: 1,
          color: isDark ? Colors.white10 : Colors.grey[200],
          indent: 50,
        ),
        _buildSmsCodeField(isDark),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String subHint,
    required bool showError,
    required bool isDark,
    bool isPassword = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isDark ? Colors.white70 : Colors.grey[600], size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  onSubmitted: onSubmitted,
                  onChanged: onChanged,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
                    isDense: true,
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 4),
              child: Text(subHint, style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _buildCaptchaField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: isDark ? Colors.white70 : Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _captchaController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleLogin(),
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
              decoration: const InputDecoration(
                hintText: "Captcha",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: _generateRandomCaptcha,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColor.accentGold.withOpacity(0.3)),
              ),
              child: Text(
                _currentCaptcha,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  color: isDark ? Colors.white : AppColor.accentGold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmsCodeField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: isDark ? Colors.white70 : Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _smsController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
              decoration: InputDecoration(
                hintText: "SMS Code",
                border: InputBorder.none,
                hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          TextButton(
            onPressed: _secondsRemaining == 0 ? _sendSmsCode : null,
            child: Text(
              _secondsRemaining > 0 ? "$_secondsRemaining s" : "Get Code",
              style: TextStyle(
                color: _secondsRemaining > 0 ? Colors.grey :AppColor.accentGold,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
