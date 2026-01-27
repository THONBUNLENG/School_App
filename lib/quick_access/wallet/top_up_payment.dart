import 'package:flutter/material.dart';

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
  State<TopUpPayment> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpPayment> {
  // Track which payment method is selected
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Subtle off-white background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Top up wallet',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select payment method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 25),

              // Option 1: Stripe
              PaymentMethodTile(
                title: 'Stripe',
                subtitle: 'Pay with your credit or debit card',
                icon: Icons.credit_card_rounded,
                isSelected: selectedIndex == 0,
                onTap: () => setState(() => selectedIndex = 0),
              ),

              const SizedBox(height: 16),

              // Option 2: Bank Transfer
              PaymentMethodTile(
                title: 'Local Bank Transfer',
                subtitle: 'Pay with your local bank account',
                icon: Icons.account_balance_rounded,
                isSelected: selectedIndex == 1,
                onTap: () => setState(() => selectedIndex = 1),
              ),

              const Spacer(),

              // Bottom Continue Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: selectedIndex != -1 ? () {
                    String method = selectedIndex == 0 ? "Stripe" : "Local Bank Transfer";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmTopUpScreen(
                          amount: widget.amount,
                          childName: widget.childName,
                          note: widget.note,
                          paymentMethod: method,
                        ),
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2), // Brand Blue
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1877F2) : Colors.grey.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Wrapper
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF), // Light blue tint
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1877F2), size: 28),
            ),
            const SizedBox(width: 16),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}