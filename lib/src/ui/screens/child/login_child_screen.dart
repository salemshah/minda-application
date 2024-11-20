import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minda_application/src/ui/widgets/labeled_text_form_field.dart';

class LoginChildScreen extends StatelessWidget {
  const LoginChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double height = constraints.maxHeight;
          return Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 1),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background/space_background2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Renseigne tes information',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sriracha'),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Image.asset(
                                  'assets/images/astronaut.png',
                                  height: height * 0.5,
                                )),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 5,
                              child: AuthForm(height: height),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class AuthForm extends StatefulWidget {
  final double height;

  const AuthForm({super.key, required this.height});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  // Controller for form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Validation logic
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pseudo is required';
    }
    if (value.length < 3) {
      return 'Pseudo must be at least 3 characters long';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, process the data
      print('Pseudo: ${_usernameController.text}');
      print('Password: ${_passwordController.text}');
      // Handle form submission logic here
    } else {
      print('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextFormField(
            label: 'Ton pseudo',
            controller: _usernameController,
            validator: _validateUsername,
            hintText: "Ex: julien_dupont_12",
          ),

          SizedBox(height: 12.h),

          // Password Field
          LabeledTextFormField(
            label: 'Ton mot de passe',
            controller: _passwordController,
            validator: _validatePassword,
            hintText: "●●●●●●●●●",
            textInputAction: TextInputAction.done,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),

          SizedBox(height: 28.h),

          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Valider',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
