
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_app/api/api_helper.dart';


class AIChatBotScreen extends StatefulWidget {
  const AIChatBotScreen({super.key});
  @override
  State<AIChatBotScreen> createState() => _AIChatBotScreenState();
}
class _AIChatBotScreenState extends State<AIChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ApiHelper _apiHelper = ApiHelper();
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  Future<void> _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty || _isLoading) return;
    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();
    try {
      final aiResponse = await _apiHelper.sendMsgApi(messages: _messages);
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': aiResponse ?? "Sorry, could you try asking again?"
        });
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': "There is a problem connecting to the system! Please check the internet."
        });
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F7F9),
      appBar: AppBar(
      title: const Text(
        'NAN JING AI Assistant',
        style: TextStyle(
          fontFamily: 'Kantumruy Pro',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFF81005B),
      centerTitle: true,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.5),
    ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildWelcomeScreen(isDark)
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(
                    msg['text'] ?? '', msg['role'] == 'user', isDark);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Lottie.asset(
                  'assets/tottie/typing.json',
                  width: 50,
                  height: 50,
                  repeat: true,
                ),
              ),
            ),
          _buildInputArea(isDark),
        ],
      ),
    );
  }
  Widget _buildChatBubble(String text, bool isUser, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8, top: 4),
              width: 55,
              height: 55,
              child: ClipOval(
                child: Lottie.asset(
                  'assets/tottie/user_robot.json',
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.android, color: Colors.white, size: 20),
                ),
              ),
            ),
          // ២. Message Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF81005B)
                    : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  fontFamily: 'Kantumruy Pro',
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildWelcomeScreen(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/tottie/robot.json', width: 180),
          const SizedBox(height: 10),
          Text(
            "Hello, brother! What questions do you have?",
            style: TextStyle(
                fontFamily: 'Kantumruy Pro',
                color: isDark ? Colors.white70 : Colors.grey[700]),
          ),
        ],
      ),
    );
  }
  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Ask something here...',
                  hintStyle:
                  const TextStyle(fontFamily: 'Kantumruy Pro', fontSize: 13),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF81005B),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
