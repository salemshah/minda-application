import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  String _code = '';
  bool _isFilled = false;

  void _submitCode() {
    if (_code.length == 5) {
      BlocProvider.of<ParentAuthBloc>(context)
          .add(ParentEmailVerificationRequested(code: _code.trim()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: BlocConsumer<ParentAuthBloc, ParentAuthState>(
          listener: (context, state) {
        if (state is ParentAuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => const EmailVerificationScreen()),
          // );
        }
        if (state is ParentAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }, builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VerificationCodeField(
              autofocus: true,
              length: 5,
              hasError: false,
              spaceBetween: 10,
              // placeholder: '•',
              size: const Size(40, 40),
              onFilled: (value) {
                setState(() {
                  _code = value;
                  _isFilled = value.length == 5;
                });
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isFilled ? _submitCode : null,
              child: const Text('Confirmer'),
            ),
          ],
        );
      }),
    );
  }
}
