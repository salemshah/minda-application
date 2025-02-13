import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/common/orientation_wrapper.dart';
import 'package:minda_application/src/ui/screens/parent/parent_email_verification_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_complete_registration_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_dashboard_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_register_screen.dart';
import 'package:minda_application/src/ui/widgets/custom_text_field.dart';
import 'package:minda_application/src/ui/widgets/loading_widget.dart';

import '../../../config/routes.dart';
import '../../common/navigate_with_oriantation.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  _ParentLoginPageState createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: "salemshahdev@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<ParentAuthBloc>(context).add(
        ParentLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Registration")),
      body: BlocConsumer<ParentAuthBloc, ParentAuthState>(
        listener: (context, state) {
          if (state is ParentLoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            if (state.parent.birthDate == null ||
                state.parent.phoneNumber == null ||
                state.parent.addressPostal == null) {
              navigateWithOrientation(
                context: context,
                orientations: [DeviceOrientation.portraitUp],
                navigationType: NavigationType.pushNamedAndRemoveUntil,
                routeName: Routes.parentCompleteRegistrationScreen,
              );

              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   Routes.parentCompleteRegistrationScreen,
              //   (route) => false,
              // );
            } else {
              navigateWithOrientation(
                context: context,
                orientations: [DeviceOrientation.portraitUp],
                navigationType: NavigationType.pushNamedAndRemoveUntil,
                routeName: Routes.parentDashboardScreen,
              );

              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   Routes.parentDashboardScreen,
              //   (route) => false,
              // );
            }
          }
          if (state is ParentLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    controller: _emailController,
                    label: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      if (!value.contains('@')) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    label: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  state is ParentAuthLoading
                      ? const LoadingWidget()
                      : ElevatedButton(
                          onPressed: _onLoginButtonPressed,
                          child: const Text("Login"),
                        ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        navigateWithOrientation(
                          context: context,
                          orientations: [DeviceOrientation.portraitUp],
                          navigationType:
                              NavigationType.pushNamedAndRemoveUntil,
                          routeName: Routes.parentRegisterScreen,
                        );
                        // Navigator.pushNamed(
                        //   context,
                        //   Routes.parentRegisterScreen,
                        // );
                      },
                      child: Text(
                        "I don't have an account",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration
                              .underline, // to indicate it's clickable
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
