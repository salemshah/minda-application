import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/common/orientation_wrapper.dart';
import 'package:minda_application/src/ui/widgets/custom_text_field.dart';
import 'package:minda_application/src/ui/widgets/loading_widget.dart';

import '../../../config/routes.dart';
import '../../common/navigate_with_oriantation.dart';

class ParentRegisterScreen extends StatefulWidget {
  const ParentRegisterScreen({super.key});

  @override
  _ParentRegisterScreenState createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: "salemshahdev@gmail.com");
  final TextEditingController _firstNameController =
      TextEditingController(text: "salem");
  final TextEditingController _lastNameController =
      TextEditingController(text: "shah");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterButtonPressed() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<ParentAuthBloc>(context).add(
        ParentRegisterRequested(
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
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
          if (state is ParentRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            navigateWithOrientation(
              context: context,
              orientations: [DeviceOrientation.portraitUp],
              navigationType: NavigationType.pushNamedAndRemoveUntil,
              routeName: Routes.parentEmailVerificationScreen,
            );

            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   Routes.parentEmailVerificationScreen,
            //   (route) => false,
            // );
          }
          if (state is ParentRegistrationFailure) {
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
                      if (value == null || value.isEmpty)
                        return "Please enter email";
                      if (!value.contains('@'))
                        return "Please enter a valid email";
                      return null;
                    },
                  ),
                  CustomTextField(
                    controller: _firstNameController,
                    label: "First Name",
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter first name"
                        : null,
                  ),
                  CustomTextField(
                    controller: _lastNameController,
                    label: "Last Name",
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter last name"
                        : null,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    label: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Please enter password";
                      if (value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  state is ParentAuthLoading
                      ? const LoadingWidget()
                      : ElevatedButton(
                          onPressed: _onRegisterButtonPressed,
                          child: const Text("Register"),
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
                          routeName: Routes.parentLoginScreen,
                        );

                        // Navigator.pushNamed(
                        //   context,
                        //   Routes.parentLoginScreen,
                        // );
                      },
                      child: Text(
                        'I already have an account',
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
