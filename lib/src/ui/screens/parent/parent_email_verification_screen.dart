import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/screens/parent/parent_complete_registration_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_login_screen.dart';

import '../../../config/routes.dart';

class ParentEmailVerificationScreen extends StatefulWidget {
  const ParentEmailVerificationScreen({super.key});

  @override
  State<ParentEmailVerificationScreen> createState() =>
      _ParentEmailVerificationScreenState();
}

class _ParentEmailVerificationScreenState
    extends State<ParentEmailVerificationScreen> {
  String _code = '';
  bool _isFilled = false;

  Timer? _timer;
  int _start = 120;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// Starts or restarts the countdown timer.
  void _startTimer() {
    setState(() {
      _start = 120;
      _isResendEnabled = false;
    });

    // Cancel any existing timer before starting a new one.
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

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

  /// This method is called when the user presses the resend button.
  void _resendCode(String email) {
    // Use the email passed in to the method when dispatching the event.
    BlocProvider.of<ParentAuthBloc>(context).add(
      ParentResendEmailVerificationRequested(email: email),
    );

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: BlocConsumer<ParentAuthBloc, ParentAuthState>(
        listener: (context, state) {
          if (state is ParentEmailVerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.parentLoginScreen,
              (route) => false,
            );
          }
          if (state is ParentEmailVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is ParentResendVerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification code resent')),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerificationCodeField(
                autofocus: true,
                length: 5,
                hasError: false,
                spaceBetween: 10,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    _isResendEnabled && state is ParentRegistrationSuccess
                        ? _resendCode(state.email)
                        : null,
                child: _isResendEnabled
                    ? const Text('Resend Verification Code')
                    : Text('Resend Code in $_start s'),
              ),
            ],
          );
        },
      ),
    );
  }
}
