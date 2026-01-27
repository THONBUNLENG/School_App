import 'package:flutter/material.dart';
import 'top_up_payment.dart';

class TopUpWallet extends StatefulWidget {
  const TopUpWallet({super.key});

  @override
  State<TopUpWallet> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpWallet> {
  String? _selectedChild = 'For all children';
  final List<String> _childOptions = [
    'For all children',
    'Child A',
    'Child B',
    'Child C'
  ];

  final TextEditingController _amountController =
  TextEditingController(text: '200.00');
  final TextEditingController _noteController = TextEditingController();

  double? _selectedQuickAmount = 200.00;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedQuickAmount = amount;
      _amountController.text = amount.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double? amountValue =
    double.tryParse(_amountController.text);

    final bool isAmountValid =
        amountValue != null && amountValue > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top-up Wallet',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Select Child (Optional)'),
                  DropdownButtonFormField<String>(
                    value: _selectedChild,
                    items: _childOptions
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedChild = v),
                  ),

                  _label('Amount'),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) =>
                        setState(() => _selectedQuickAmount = null),
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _quickBtn(50),
                      _quickBtn(100),
                      _quickBtn(200),
                      _quickBtn(500),
                    ],
                  ),

                  _label('Note (Optional)'),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAmountValid
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TopUpPayment(
                        amount: amountValue!, // ✅ double
                        childName:
                        _selectedChild ?? 'For all children',
                        note: _noteController.text,
                      ),
                    ),
                  );
                }
                    : null,
                child: const Text('Proceed to Payment',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500)),
  );

  Widget _quickBtn(double amount) {
    final bool selected = _selectedQuickAmount == amount;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () => _selectQuickAmount(amount),
          style: ElevatedButton.styleFrom(
            backgroundColor:
            selected ? Colors.blue : Colors.blue.withOpacity(0.1),
            foregroundColor:
            selected ? Colors.white : Colors.blue,
          ),
          child: Text('\$${amount.toStringAsFixed(0)}'),
        ),
      ),
    );
  }
}
