import 'package:date_input_form_field/date_input_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/config/routes.dart';
import 'package:minda_application/src/ui/common/navigate_with_oriantation.dart';
import 'package:minda_application/src/ui/widgets/custom_text_field.dart';
import 'package:minda_application/src/ui/widgets/loading_widget.dart';

class ParentCompleteRegistrationScreen extends StatefulWidget {
  const ParentCompleteRegistrationScreen({super.key});

  @override
  State<ParentCompleteRegistrationScreen> createState() =>
      _ParentCompleteRegistrationScreenState();
}

class _ParentCompleteRegistrationScreenState
    extends State<ParentCompleteRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _birthDate =
      TextEditingController(text: "14/12/2000");
  DateTime dateOfBirth =
      DateTime.now().subtract(const Duration(days: 365 * 18));
  final TextEditingController _phoneNumber =
      TextEditingController(text: "0745434523");
  final TextEditingController _addressPostal =
      TextEditingController(text: "60000");

  @override
  void dispose() {
    _birthDate.dispose();
    _phoneNumber.dispose();
    _addressPostal.dispose();
    super.dispose();
  }

  void _onRegisterButtonPressed() {
    if (_formKey.currentState!.validate()) {
      DateFormat inputFormat = DateFormat("dd/MM/yyyy");
      DateTime convertedDate = inputFormat.parse(_birthDate.text.trim());
      String isoDate = convertedDate.toUtc().toIso8601String();

      BlocProvider.of<ParentAuthBloc>(context).add(
        ParentCompleteRegistrationRequested(
          birthDate: isoDate,
          phoneNumber: _phoneNumber.text.trim(),
          addressPostal: _addressPostal.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // No AppBar for a full-screen wavy design
      body: LayoutBuilder(
        builder: (context, constraints) {
          double textScaleFactor =
              constraints.maxWidth / 600; // for dynamic scaling

          return BlocConsumer<ParentAuthBloc, ParentAuthState>(
            listener: (context, state) {
              if (state is ParentCompleteRegistrationSuccess) {
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
                  routeName: Routes.parentDashboardScreen,
                );
              }
              if (state is ParentCompleteRegistrationFailure) {
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
                        child: Container(
                          height: size.height * 0.35,
                          width: double.infinity,
                          color: const Color(0xFF6959C3),
                        ),
                      ),
                      // 2) HEADING TEXT ON TOP OF THE WAVE
                      Positioned(
                        top: size.height * 0.08,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 60),
                              Text(
                                'Complete Registration',
                                style: TextStyle(
                                  fontSize: 28 * textScaleFactor,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fill in your details to continue',
                                style: TextStyle(
                                  fontSize: 16 * textScaleFactor,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 3) FORM CONTAINER
                      Positioned(
                        top: size.height * 0.32 - 40,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 70),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DateInputFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    format: 'dd/MM/yyyy',
                                    controller: _birthDate,
                                    validator: (value) {
                                      final text = value?.$1;
                                      final date = value?.$2;
                                      if (date == null) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please enter a date';
                                        } else if (text.isNotEmpty) {
                                          return 'Please enter a valid date\nFormat: dd/mm/yyyy\nExample: 01/01/2000';
                                        }
                                        return null;
                                      }
                                      if (DateTime.now()
                                          .subtract(
                                              const Duration(days: 365 * 18))
                                          .isBefore(date)) {
                                        return 'You must be 18 years old';
                                      } else if (DateTime.now()
                                          .subtract(
                                              const Duration(days: 365 * 100))
                                          .isAfter(date)) {
                                        return 'You must be less than 100 years old';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      final newDate = value.$2;
                                      if (newDate == null) return;
                                      setState(() {
                                        dateOfBirth = newDate;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.date_range),
                                      hintText: 'Date of birth',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14.0)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Phone Number Field
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    controller: _phoneNumber,
                                    prefixIcon: Icons.phone_iphone,
                                    hintText: 'Phone number',
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter phone number"
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Postal Code Field
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    controller: _addressPostal,
                                    prefixIcon: Icons.home,
                                    hintText: 'Postal Code',
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter postal code"
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // CONFIRM BUTTON
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
                                            "CONFIRMER",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
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
        },
      ),
    );
  }
}

/// Custom clipper to create a wavy shape at the top.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start at the top left
    path.lineTo(0, size.height - 50);
    // First curve
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    // Second curve
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    // End at the top right
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
