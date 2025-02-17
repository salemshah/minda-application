import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import '../../../../widgets/custom_dropdown_form_field.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/input_date_picker.dart';
import 'package:intl/intl.dart';

class ParentChildRegistrationScreen extends StatefulWidget {
  const ParentChildRegistrationScreen({super.key});

  @override
  State<ParentChildRegistrationScreen> createState() =>
      _ParentChildRegistrationScreenState();
}

class _ParentChildRegistrationScreenState
    extends State<ParentChildRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte.
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedGender;
  String? _selectedSchoolLevel;
  DateTime? selectedDate;

  // Validation de la date.
  String? _dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez sélectionner une date";
    }
    return null;
  }

  void _handleDateChanged(DateTime date) {
    setState(() {
      _birthDateController.text = DateFormat("dd/MM/yyyy").format(date);
    });
  }

  // Options pour le genre.
  final List<String> _genders = ['Male', 'Female'];

  // Niveaux scolaires.
  final List<String> _schoolLevels = [
    'CE1',
    'CE2',
    'CM1',
    'CM2',
    'Sixième',
    'Cinquième',
    'Quatrième',
    'Troisième',
    'Seconde',
    'Première',
    'Terminale'
  ];

  // Soumission du formulaire en déclenchant l'événement d'inscription.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      DateFormat inputFormat = DateFormat("dd/MM/yyyy");
      DateTime convertedDate =
          inputFormat.parse(_birthDateController.text.trim());
      String birthDate = convertedDate.toUtc().toIso8601String();
      BlocProvider.of<ParentAuthBloc>(context)
          .add(ParentChildRegistrationRequested(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text.trim(),
        birthDate: birthDate,
        gender: _selectedGender.toString().trim(),
        schoolLevel: _selectedSchoolLevel.toString().trim(),
      ));
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Widget pour afficher l'en-tête d'une section avec titre et description.
  Widget buildSectionHeader(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: <Widget>[
          Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Divider()),
        ]),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription de l'enfant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ParentAuthBloc, ParentAuthState>(
          listener: (context, state) {
            if (state is ParentChildRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Inscription réussie !"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is ParentChildRegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Erreur d'inscription : ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ParentAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Informations personnelles.
                    buildSectionHeader(
                      "Informations personnelles",
                      "Veuillez renseigner les informations personnelles de l'enfant.",
                    ),
                    CustomTextFormField(
                      controller: _firstNameController,
                      hintText: "Prénom",
                      prefixIcon: Icons.person,
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Veuillez saisir le prénom"
                          : null,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: _lastNameController,
                      hintText: "Nom de famille",
                      prefixIcon: Icons.person,
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Veuillez saisir le nom de famille"
                          : null,
                    ),
                    const SizedBox(height: 10),
                    InputDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now(),
                      controller: _birthDateController,
                      validator: _dateValidator,
                      onDateChanged: _handleDateChanged,
                      hintText: "Date de naissance",
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownFormField<String>(
                      value: _selectedGender,
                      items: _genders,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                      hintText: "Genre",
                      prefixIcon: Icons.person_outline,
                      validator: (value) => (value == null)
                          ? "Veuillez sélectionner le genre"
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Sécurité.
                    buildSectionHeader(
                      "Sécurité",
                      "Veuillez définir un mot de passe sécurisé.",
                    ),
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: "Mot de passe",
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6)
                          ? "Le mot de passe doit comporter au moins 6 caractères"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    // Section 3: Informations scolaires.
                    buildSectionHeader(
                      "Informations scolaires",
                      "Veuillez renseigner le niveau scolaire de l'enfant.",
                    ),
                    CustomDropdownFormField<String>(
                      value: _selectedSchoolLevel,
                      items: _schoolLevels,
                      onChanged: (value) =>
                          setState(() => _selectedSchoolLevel = value),
                      hintText: "Niveau scolaire",
                      prefixIcon: Icons.school,
                      validator: (value) => (value == null)
                          ? "Veuillez sélectionner le niveau scolaire"
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Bouton de soumission.
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("S'inscrire"),
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
