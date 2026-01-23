import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_app/screen/home/home_screen/change_notifier.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/home_profile_screen.dart';
import 'package:school_app/screen/profile_login/qr_login.dart';
import 'package:school_app/screen/profile_login/wechat_login.dart';

const Color nandaPurple = Color(0xFF81005B);

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
  bool _userErr = false,
      _passErr = false,
      _capErr = false,
      _phoneErr = false,
      _smsErr = false;
  String _passSubHint = "请输入密码";

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
    _currentCaptcha = String.fromCharCodes(
        Iterable.generate(
            4, (_) => chars.codeUnitAt(Random().nextInt(chars.length)))
    );
    if (mounted) setState(() {
      _captchaController.clear();
      _capErr = false;
    });
  }

  void _sendSmsCode() {
    if (_phoneController.text.length < 9) {
      setState(() => _phoneErr = true);
      return;
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
        if (_secondsRemaining > 0)
          _secondsRemaining--;
        else
          _timer?.cancel();
      });
    });
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    double strength = 0.0;
    if (password.length >= 8) strength += 0.4;
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    return strength;
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.4) return Colors.redAccent;
    if (strength <= 0.7) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  bool _isPasswordValid(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(password);
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_currentTab == 0) {
        _userErr = _usernameController.text.isEmpty;
        String pass = _passwordController.text;
        if (pass.isEmpty) {
          _passErr = true;
          _passSubHint = "请输入密码 ";
        } else if (!_isPasswordValid(pass)) {
          _passErr = true;
          _passSubHint =
          "Password8位以上且含大小写字母 ";
        } else {
          _passErr = false;
        }
        _capErr = _captchaController.text.trim().toLowerCase() !=
            _currentCaptcha.toLowerCase();
      } else {
        _phoneErr = _phoneController.text.length < 9;
        _smsErr = _smsController.text.isEmpty;
      }
    });

    if (_userErr || _passErr || _capErr || _phoneErr || _smsErr) {
      if (_capErr) {
        _showError("验证码错误");
        _generateRandomCaptcha();
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _currentTab == 0
              ? _usernameController.text.trim()
              : _phoneController.text.trim(),
          'password': _currentTab == 0
              ? _passwordController.text
              : _smsController.text,
          'type': _currentTab == 0 ? 'account' : 'sms',
        }),
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) => const HomeProfileScreen()), (
              route) => false);
        } else {
          _showError(data['message'] ?? "登录失败");
          _generateRandomCaptcha();
        }
      } else {
        _showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("网络连接失败");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- UI Section ---

  @override
  Widget build(BuildContext context) {
    final isDark = Provider
        .of<ThemeManager>(context)
        .isDarkMode;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(
              'assets/image/background_login.png', fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: nandaPurple))),
          Positioned.fill(child: Container(
              color: isDark ? Colors.black.withOpacity(0.75) : Colors.black
                  .withOpacity(0.4))),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildTabs(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.12) : Colors
                            .white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(
                            0.2), blurRadius: 15, offset: const Offset(0, 8))
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

  Widget _buildAccountForm(bool isDark) {
    double strength = _calculatePasswordStrength(_passwordController.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildField(controller: _usernameController,
            icon: Icons.person_outline,
            hint: "Username",
            showError: _userErr,
            subHint: "请输入用户名",
            isDark: isDark),
        Divider(height: 1,
            color: isDark ? Colors.white10 : Colors.grey[200],
            indent: 50),
        _buildField(
          controller: _passwordController,
          icon: Icons.lock_outline,
          hint: "Password",
          isPassword: !_isPasswordVisible,
          showError: _passErr,
          subHint: _passSubHint,
          isDark: isDark,
          onChanged: (v) => setState(() {}),
          onSubmitted: (v) => _handleLogin(),
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20, color: isDark ? Colors.white70 : Colors.grey),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
        if (_passwordController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: strength,
                    backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _getStrengthColor(strength)),
                    minHeight: 3),
                const SizedBox(height: 4),
                Text(strength <= 0.4 ? "Weak" : strength <= 0.7
                    ? "Medium"
                    : "Strong", style: TextStyle(
                    color: _getStrengthColor(strength),
                    fontSize: 9,
                    fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        Divider(height: 1,
            color: isDark ? Colors.white10 : Colors.grey[200],
            indent: 50),
        _buildCaptchaField(isDark),
      ],
    );
  }

  Widget _buildSmsForm(bool isDark) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildField(controller: _phoneController,
              icon: Icons.phone_android,
              hint: "Mobile Number",
              showError: _phoneErr,
              subHint: "请输入正确的手机号",
              isDark: isDark,
              keyboardType: TextInputType.phone),
          Divider(height: 1,
              color: isDark ? Colors.white10 : Colors.grey[200],
              indent: 50),
          _buildSmsCodeField(isDark),
        ],
      );

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String subHint,
    bool isPassword = false,
    required bool showError,
    required bool isDark,
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
              Icon(icon, color: isDark ? Colors.white70 : Colors.grey[600],
                  size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  onSubmitted: onSubmitted,
                  onChanged: onChanged,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black,
                      fontSize: 15),
                  decoration: InputDecoration(hintText: hint,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[400]),
                      isDense: true),
                ),
              ),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
          if (showError) Padding(
              padding: const EdgeInsets.only(left: 34, top: 4),
              child: Text(subHint, style: const TextStyle(
                  color: Colors.redAccent, fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildCaptchaField(bool isDark) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Icon(Icons.verified_user_outlined,
              color: isDark ? Colors.white70 : Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
              child: TextField(
                  controller: _captchaController,
                  // បន្ថែម textInputAction ដើម្បីឱ្យងាយស្រួលចុច Done
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black,
                      fontSize: 15),
                  decoration: InputDecoration(hintText: "Captcha",
                      border: InputBorder.none,
                      isDense: true)
              )
          ),
          GestureDetector(
              onTap: _generateRandomCaptcha,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: nandaPurple.withOpacity(0.1), // ដូរពណ៌ឱ្យប្លែកបន្តិច
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: nandaPurple.withOpacity(0.3)), // ថែមរង្វង់ជុំវិញ
                  ),
                  child: Text(
                      _currentCaptcha,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2,
                        color: isDark ? Colors.white : nandaPurple,
                        // ឱ្យអក្សរពណ៌ស្វាយងាយមើល
                        fontSize: 16,
                      )
                  )
              )
          ),
        ]),
      );

  Widget _buildSmsCodeField(bool isDark) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Icon(Icons.shield_outlined,
              color: isDark ? Colors.white70 : Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: _smsController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black, fontSize: 15),
              decoration: InputDecoration(hintText: "SMS Code",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey[400],
                      fontSize: 14)))),
          TextButton(onPressed: _secondsRemaining == 0 ? _sendSmsCode : null,
              child: Text(
                  _secondsRemaining > 0 ? "$_secondsRemaining s" : "获取验证码",
                  style: TextStyle(
                      color: _secondsRemaining > 0 ? Colors.grey : nandaPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 13))),
        ]),
      );

  Widget _buildHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/image/logo_school.png', height: 45,
          color: Colors.white,
          errorBuilder: (c, e, s) =>
          const Icon(
              Icons.school, color: Colors.white, size: 40)),
      const SizedBox(width: 10),
      Column(children: const [
        Text("南京大学", style: TextStyle(color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif')),
        Text("NANJING UNIVERSITY", style: TextStyle(
            color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
      ]),
      Container(margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 25,
          width: 1,
          color: Colors.white30),
      const Text("统一身份认证", style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
    ]);
  }

  Widget _buildTabs() {
    return Row(children: [
      _tabItem("账号登录", 0),
      const SizedBox(width: 30),
      _tabItem("手机验证码", 1),
    ]);
  }

  Widget _tabItem(String title, int index) {
    bool active = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Column(children: [
        Text(title, style: TextStyle(
            color: active ? Colors.white : Colors.white60,
            fontSize: 15,
            fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        const SizedBox(height: 5),
        AnimatedContainer(duration: const Duration(milliseconds: 300),
            height: 3,
            width: active ? 20 : 0,
            color: Colors.white),
      ]),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(width: double.infinity,
        height: 50,
        child: ElevatedButton(onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(backgroundColor: nandaPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: _isLoading ? const SizedBox(height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)) : const Text("登录",
                style: TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))));
  }

  Widget _buildBottomLinks(bool isDark) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {},
                child: Text("在线帮助", style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.white70,
                    fontSize: 12))),
            TextButton(onPressed: () {},
                child: Text("忘记密码", style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.white70,
                    fontSize: 12)))
          ]);

  Widget _buildSocialLogin(bool isDark) =>
      Column(children: [
        Row(children: [
          const Expanded(child: Divider(color: Colors.white24)),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("其他登录方式",
                  style: TextStyle(color: Colors.white60, fontSize: 11))),
          const Expanded(child: Divider(color: Colors.white24))
        ]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _socialIcon(Icons.wechat, "WeChat", () =>
              Navigator.push(context,
              MaterialPageRoute(builder: (c) => const WeChatLoginScreen()))),
          const SizedBox(width: 40),
          _socialIcon(Icons.qr_code_scanner, "扫码登录", () =>
              Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const QRCodeScreen()))),
        ]),
      ]);

  Widget _socialIcon(IconData icon, String label, VoidCallback tap) =>
      InkWell(
      onTap: tap,
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9))
      ]));
}