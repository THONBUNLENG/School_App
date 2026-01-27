import 'package:flutter/material.dart';
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

  void _handlePayment(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1B85F3)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopUpSuccessScreen (
            amount: amount,
            paymentMethod: paymentMethod,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Confirm Top-up',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'You are adding',
              style: TextStyle(fontSize: 18, color: Color(0xFF707E94)),
            ),
            const SizedBox(height: 8),
            Text(
              '\$$amount',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A233E),
              ),
            ),
            const SizedBox(height: 40),

            // Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow('For Child', childName),
                  const Divider(height: 32),
                  _buildPaymentRow('Payment Method', paymentMethod),
                  const Divider(height: 32),
                  _buildDetailRow('Note', note.isEmpty ? '-' : note),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () => _handlePayment(context),
                icon: const Icon(Icons.lock_outline),
                label: const Text(
                  'Confirm & Proceed to Pay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B85F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF707E94))),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A233E),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF707E94))),
        const Spacer(),
        const Icon(Icons.credit_card, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A233E),
          ),
        ),
      ],
    );
  }
}
