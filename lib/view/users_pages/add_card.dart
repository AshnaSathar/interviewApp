import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/card_controller.dart';
import 'package:flutter_application_1/view/users/payment.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _isDefault = false;

  String? _cardError;
  String? _cvvError;
  String? _expiryError;

  final CardController _cardController = CardController();

  Future<void> _addCard() async {
    final cardNumber = _cardNumberController.text.trim();
    final expiry = _expiryDateController.text.trim();
    final cvv = _cvvController.text.trim();

    setState(() {
      _cardError =
          cardNumber.length != 16 ? 'Card number must be 16 digits' : null;
      _cvvError = cvv.length != 3 ? 'CVV must be 3 digits' : null;
      _expiryError = !RegExp(r'^\d{2}/\d{4}$').hasMatch(expiry)
          ? 'Enter expiry as MM/YYYY'
          : null;
    });

    if (_cardError != null || _cvvError != null || _expiryError != null) return;

    try {
      await _cardController.addCard(
        cardNumber: cardNumber,
        expiry: expiry,
        cvv: cvv,
        isDefault: _isDefault,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Card added successfully!${_isDefault ? ' Set as default.' : ''}"),
        ),
      );

      _cardNumberController.clear();
      _expiryDateController.clear();
      _cvvController.clear();
      setState(() {
        _isDefault = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding card: $error")),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: screenWidth < 600 ? screenWidth : 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Card Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    errorText: _cardError,
                    border: const OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.number,
                        maxLength: 7,
                        onChanged: (value) {
                          if (value.length == 2 && !value.contains('/')) {
                            _expiryDateController.text = '$value/';
                            _expiryDateController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _expiryDateController.text.length),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Expiry (MM/YYYY)',
                          errorText: _expiryError,
                          border: const OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _cvvController,
                        obscureText: true,
                        obscuringCharacter: '•',
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          errorText: _cvvError,
                          border: const OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isDefault,
                      onChanged: (val) {
                        setState(() {
                          _isDefault = val ?? false;
                        });
                      },
                    ),
                    const Text("Set as default card"),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _addCard,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Card',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
