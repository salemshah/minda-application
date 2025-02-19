import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/config/routes.dart';
import 'package:minda_application/src/ui/common/navigate_with_oriantation.dart';
import 'package:minda_application/src/ui/widgets/custom_text_field.dart';
import 'package:minda_application/src/ui/widgets/loading_widget.dart';

class ParentRegisterScreen extends StatefulWidget {
  const ParentRegisterScreen({super.key});

  @override
  State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Optional: dynamic text scaling if you want it to adapt to screen width.
          double textScaleFactor = constraints.maxWidth / 600;

          return BlocConsumer<ParentAuthBloc, ParentAuthState>(
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
              return SingleChildScrollView(
                child: SizedBox(
                  height: size.height,
                  child: Stack(
                    children: [
                      // 1) WAVE-SHAPED CONTAINER AT THE TOP
                      ClipPath(
                        clipper: WaveClipper(), // Custom clipper below
                        child: Container(
                          height: size.height * 0.38,
                          width: double.infinity,
                          color: const Color(0xFF6959C3),
                          // or use a gradient:
                          // decoration: const BoxDecoration(
                          //   gradient: LinearGradient(
                          //     colors: [...],
                          //     begin: Alignment.topLeft,
                          //     end: Alignment.bottomRight,
                          //   ),
                          // ),
                        ),
                      ),

                      // 2) TOP ILLUSTRATION & TEXT
                      Positioned(
                        top: size.height * 0.05,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Illustration
                            SizedBox(
                              height: size.height * 0.15,
                              child: Image.asset(
                                'assets/images/spaceship.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Heading
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 32 * textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Subheading
                            Text(
                              'Join the family',
                              style: TextStyle(
                                fontSize: 16 * textScaleFactor,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3) REGISTRATION FORM
                      Positioned(
                        top: size.height * 0.35 - 40, // Overlap wave slightly
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 80),
                                // First Name
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    prefixIcon: Icons.person,
                                    controller: _firstNameController,
                                    hintText: 'First Name',
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter first name"
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Last Name
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    prefixIcon: Icons.person,
                                    controller: _lastNameController,
                                    hintText: 'Last Name',
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter last name"
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Email
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    prefixIcon: Icons.email,
                                    controller: _emailController,
                                    hintText: 'Email',
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
                                ),
                                const SizedBox(height: 16),

                                // Password
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    prefixIcon: Icons.lock,
                                    obscureText: true,
                                    controller: _passwordController,
                                    hintText: 'Password',
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
                                ),
                                const SizedBox(height: 20),

                                // REGISTER BUTTON
                                state is ParentAuthLoading
                                    ? const LoadingWidget()
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: _onRegisterButtonPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF6959C3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Enregistrer',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 20),

                                // ALREADY HAVE AN ACCOUNT?
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      navigateWithOrientation(
                                        context: context,
                                        orientations: [
                                          DeviceOrientation.portraitUp
                                        ],
                                        navigationType: NavigationType
                                            .pushNamedAndRemoveUntil,
                                        routeName: Routes.parentLoginScreen,
                                      );
                                    },
                                    child: const Text(
                                      'I already have an account',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// A custom clipper to create a wavy shape at the top.
/// (Same as in your Login screen)
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from the top-left
    path.lineTo(0, size.height - 50);

    // First control point + end point
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second control point + end point
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Close the path by drawing the line to top-right
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
