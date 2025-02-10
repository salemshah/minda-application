import 'package:flutter/material.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';

void main() {
  runApp(const EmailVerificationScreen());
}

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Email Verification')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: MyCodeInput(),
        ),
      ),
    );
  }
}

class MyCodeInput extends StatefulWidget {
  const MyCodeInput({super.key});

  @override
  State<MyCodeInput> createState() => _MyCodeInputState();
}

class _MyCodeInputState extends State<MyCodeInput> {
  String _code = '';
  bool _isFilled = false;

  void _submitCode() {
    if (_code.length == 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code $_code Submitted successfully! 🎉')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VerificationCodeField(
          autofocus: true,
          length: 5,
          hasError: false, // Removed 'true' to avoid forced error
          spaceBetween: 10,
          placeholder: '•',
          size: const Size(56, 62),
          onFilled: (value) {
            setState(() {
              _code = value;
              _isFilled = value.length == 5;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isFilled ? _submitCode : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
