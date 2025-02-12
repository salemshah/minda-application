import 'package:date_input_form_field/date_input_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/common/orientation_wrapper.dart';
import 'package:minda_application/src/ui/screens/parent/email_verification_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_dashboard_screen.dart';
import 'package:minda_application/src/ui/widgets/custom_text_field.dart';
import 'package:minda_application/src/ui/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

class ParentCompleteRegistrationScreen extends StatefulWidget {
  const ParentCompleteRegistrationScreen({super.key});

  @override
  _ParentRegisterScreenState createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentCompleteRegistrationScreen> {
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
              addressPostal: _addressPostal.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationWrapper(
      orientations: const [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Parent Registration")),
        body: BlocConsumer<ParentAuthBloc, ParentAuthState>(
          listener: (context, state) {
            if (state is ParentCompleteRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ParentDashboardScreen()),
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DateInputFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            .subtract(const Duration(days: 365 * 18))
                            .isBefore(date)) {
                          return 'You must be 18 years old';
                        } else if (DateTime.now()
                            .subtract(const Duration(days: 365 * 100))
                            .isAfter(date)) {
                          return 'You must be less than 100 years old';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final dateOfBirth = value.$2;
                        if (dateOfBirth == null) return;
                        setState(() {
                          this.dateOfBirth = dateOfBirth;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    CustomTextField(
                      controller: _phoneNumber,
                      label: "Phone number",
                      validator: (value) => value == null || value.isEmpty
                          ? "Please enter phone number"
                          : null,
                    ),
                    CustomTextField(
                      controller: _addressPostal,
                      label: "Address postal",
                      validator: (value) => value == null || value.isEmpty
                          ? "Please enter address postal"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    state is ParentAuthLoading
                        ? const LoadingWidget()
                        : ElevatedButton(
                            onPressed: _onRegisterButtonPressed,
                            child: const Text("Confirmer"),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
