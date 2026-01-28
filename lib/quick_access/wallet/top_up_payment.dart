import 'package:flutter/material.dart';
import '../../config/app_color.dart';
import '../../model/payment_mode.dart';
import 'comfirm_top_up.dart';

class TopUpPayment extends StatefulWidget {
  final double amount;
  final String childName;
  final String note;

  const TopUpPayment({
    super.key,
    required this.amount,
    required this.childName,
    required this.note,
  });

  @override
  State<TopUpPayment> createState() => _TopUpPaymentState();
}

class _TopUpPaymentState extends State<TopUpPayment> {
  int selectedIndex = -1;
  String selectedBank = '';
  final List<String> banks = ['ABA', 'KHQR', 'ACLEDA', 'Canadia Bank'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF806B9F), Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Select payment method',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 25),
                      PaymentMethodTile(
                        title: 'Stripe Payment',
                        subtitle: 'Credit or debit card',
                        icon: Icons.credit_card_rounded,
                        isSelected: selectedIndex == 0,
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                            selectedBank = '';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      PaymentMethodTile(
                        title: 'Local Bank Transfer',
                        subtitle: selectedBank.isEmpty ? 'Select bank' : selectedBank,
                        icon: Icons.account_balance_rounded,
                        isSelected: selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                          _showBankSelectionDialog();
                        },
                      ),
                      const Spacer(),
                      _buildContinueButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        const Expanded(
            child: Text('Top Up Payment',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(width: 48),
      ],
    );
  }

  void _showBankSelectionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Bank'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: banks.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(banks[index]),
                onTap: () {
                  setState(() {
                    selectedBank = banks[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    bool isEnabled = selectedIndex != -1 && (selectedIndex == 0 || selectedBank.isNotEmpty);
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
          String method = selectedIndex == 0 ? "Stripe" : selectedBank;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmTopUpScreen(
                amount: widget.amount,
                childName: widget.childName,
                note: widget.note,
                paymentMethod: method,
              ),
            ),
          );
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColor.accentGold : Colors.white10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text('Continue',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isEnabled ? Colors.black87 : Colors.white24)),
      ),
    );
  }
}
