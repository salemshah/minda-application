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

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: "salemshahdev@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");

  bool _rememberMe = false;

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Remove or comment out the AppBar to match the mockup (no top app bar).
      // appBar: AppBar(title: const Text("Parent Registration")),

      body: LayoutBuilder(builder: (context, constraints) {
        double textScaleFactor =
            constraints.maxWidth / 600; // Adjust for different screen widths

        return BlocConsumer<ParentAuthBloc, ParentAuthState>(
          listener: (context, state) {
            if (state is ParentLoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              // Check if user data is incomplete => go to "Complete Registration"
              if (state.parent.birthDate == null ||
                  state.parent.phoneNumber == null ||
                  state.parent.addressPostal == null) {
                navigateWithOrientation(
                  context: context,
                  orientations: [DeviceOrientation.portraitUp],
                  navigationType: NavigationType.pushNamedAndRemoveUntil,
                  routeName: Routes.parentCompleteRegistrationScreen,
                );
              } else {
                navigateWithOrientation(
                  context: context,
                  orientations: [DeviceOrientation.portraitUp],
                  navigationType: NavigationType.pushNamedAndRemoveUntil,
                  routeName: Routes.parentDashboardScreen,
                );
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
            return SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: Stack(
                  children: [
                    // 1) WAVE-SHAPED CONTAINER AT THE TOP
                    ClipPath(
                      clipper: WaveClipper(),
                      // See the custom clipper below
                      child: Container(
                        height: size.height * 0.38,
                        width: double.infinity,
                        color: const Color(
                            0xFF6959C3), // Customize your wave color
                        // You can also add a gradient decoration if needed:
                        // decoration: BoxDecoration(
                        //   gradient: LinearGradient(...),
                        // ),
                      ),
                    ),

                    Positioned(
                      top: size.height * 0.05,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * 0.15,
                            child: Image.asset(
                              'assets/images/spaceship.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 32 * textScaleFactor,
                              // Scales dynamically
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Login to your account',
                            style: TextStyle(
                              fontSize: 16 * textScaleFactor,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.35 - 40,
                      // Slightly overlap the wave
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // USERNAME FIELD
                              SizedBox(height: 100),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomTextFormField(
                                  prefixIcon: Icons.email,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter email";
                                    }
                                    if (!value.contains('@')) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                  hintText: 'Email address',
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
                              const SizedBox(height: 16),

                              // REMEMBER ME & FORGOT PASSWORD
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                      ),
                                      const Text('Remember me'),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle forgot password
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // LOGIN BUTTON
                              state is ParentAuthLoading
                                  ? const LoadingWidget()
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: _onLoginButtonPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF6959C3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Se connecter',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                      ),
                                    ),

                              // SPACING
                              const SizedBox(height: 16),

                              // DON'T HAVE AN ACCOUNT? SIGN UP
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      navigateWithOrientation(
                                        context: context,
                                        orientations: [
                                          DeviceOrientation.portraitUp
                                        ],
                                        navigationType: NavigationType
                                            .pushNamedAndRemoveUntil,
                                        routeName: Routes.parentRegisterScreen,
                                      );
                                    },
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
      }),
    );
  }
}

/// A custom clipper to create a wavy shape at the top.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from the top-left
    path.lineTo(0, size.height - 50);

    // First control point and end point for the bezier curve
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second control point and end point
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
