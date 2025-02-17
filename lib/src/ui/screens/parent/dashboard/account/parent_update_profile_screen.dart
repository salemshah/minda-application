import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/widgets/change_password_dialog.dart';
import 'package:minda_application/src/ui/widgets/custom_text_field.dart';
import 'package:minda_application/src/ui/widgets/input_date_picker.dart';

class ParentUpdateProfileScreen extends StatefulWidget {
  const ParentUpdateProfileScreen({super.key});

  @override
  State<ParentUpdateProfileScreen> createState() =>
      _ParentUpdateProfileScreenState();
}

class _ParentUpdateProfileScreenState extends State<ParentUpdateProfileScreen> {
  // Text Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _addressPostalController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Variables to store original values for comparison
  String _originalFirstName = "";
  String _originalLastName = "";
  String _originalPhone = "";
  String _originalAddressPostal = "";
  String _originalBirthDate = "";

  bool _hasChanged = false;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch the profile data on screen load.
    context.read<ParentAuthBloc>().add(ParentGetProfileRequested());

    // Add listeners to detect changes
    _firstNameController.addListener(_checkIfChanged);
    _lastNameController.addListener(_checkIfChanged);
    _phoneController.addListener(_checkIfChanged);
    _addressPostalController.addListener(_checkIfChanged);
    _dateController.addListener(_checkIfChanged);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    _addressPostalController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Called when user picks a date from the date picker.
  void _handleDateChanged(DateTime date) {
    setState(() {
      // Update _dateController with the formatted date.
      _dateController.text = DateFormat("dd/MM/yyyy").format(date);
    });
  }

  // Validate date input.
  String? _dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select a date";
    }
    return null;
  }

  // Compare current controller values with the original values.
  void _checkIfChanged() {
    final changed = _firstNameController.text.trim() != _originalFirstName ||
        _lastNameController.text.trim() != _originalLastName ||
        _phoneController.text.trim() != _originalPhone ||
        _addressPostalController.text.trim() != _originalAddressPostal ||
        _dateController.text.trim() != _originalBirthDate;
    if (changed != _hasChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _hasChanged = changed;
          });
        }
      });
    }
  }

  // Called when "Update" button is pressed.
  void _onUpdateProfile() {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateTime convertedDate = inputFormat.parse(_dateController.text.trim());
    String birthDateString = convertedDate.toUtc().toIso8601String();

    context.read<ParentAuthBloc>().add(
          ParentUpdateProfileRequested(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            birthDate: birthDateString,
            phoneNumber: _phoneController.text.trim(),
            addressPostal: _addressPostalController.text.trim(),
          ),
        );
  }

  // Called when "Change Password" button is pressed.
  void _onChangePassword() {
    showChangePasswordDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return BlocConsumer<ParentAuthBloc, ParentAuthState>(
      listener: (context, state) {
        // When profile data is successfully fetched, populate the form and store original values.
        if (state is ParentGetProfileSuccess) {
          setState(() {
            _originalFirstName = state.parent.firstName;
            _originalLastName = state.parent.lastName;
            _originalPhone = state.parent.phoneNumber ?? '';
            _originalAddressPostal = state.parent.addressPostal ?? '';
            // Convert ISO date to dd/MM/yyyy.
            if (state.parent.birthDate != null) {
              DateTime parsedDate =
                  DateTime.parse(state.parent.birthDate.toString());
              _originalBirthDate = DateFormat("dd/MM/yyyy").format(parsedDate);
              String formattedDate =
                  DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").format(parsedDate);
              selectedDate = DateTime.parse(formattedDate);
              _dateController.text = _originalBirthDate;
            }
            // Populate controllers.
            _firstNameController.text = _originalFirstName;
            _lastNameController.text = _originalLastName;
            _phoneController.text = _originalPhone;
            _addressPostalController.text = _originalAddressPostal;
          });
        }
        // Show error if fetching fails.
        if (state is ParentGetProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fetch Error: ${state.error}')),
          );
        }
        // On successful update, show a success message.
        if (state is ParentUpdateProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          // Update original values since the profile was updated.
          setState(() {
            _originalFirstName = _firstNameController.text.trim();
            _originalLastName = _lastNameController.text.trim();
            _originalPhone = _phoneController.text.trim();
            _originalAddressPostal = _addressPostalController.text.trim();
            _originalBirthDate = _dateController.text.trim();
            _hasChanged = false;
          });
        }
        // Show error if update fails.
        if (state is ParentUpdateProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        if (state is ParentAuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1) Curved header with back arrow.
                SizedBox(
                  height: size.height * 0.32,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: TopCurveClipper(),
                        child: Container(
                          height: size.height * 0.28,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFCF9EF3),
                                Color(0xFFF5D9F2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      // Back arrow.
                      Positioned(
                        top: topPadding,
                        left: 16,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      // Avatar with edit icon.
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                              ),
                              Positioned(
                                right: -2,
                                bottom: 0,
                                child: InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Edit Avatar Tapped')),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 2) "Edit Profile" text.
                const SizedBox(height: 10),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 3) Form fields.
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // First Name.
                      CustomTextFormField(
                        prefixIcon: Icons.account_circle_outlined,
                        controller: _firstNameController,
                        hintText: 'First Name',
                      ),
                      const SizedBox(height: 10),
                      // Last Name.
                      CustomTextFormField(
                        prefixIcon: Icons.account_circle,
                        controller: _lastNameController,
                        hintText: 'Last Name',
                      ),
                      const SizedBox(height: 10),
                      // Phone Number.
                      CustomTextFormField(
                        prefixIcon: Icons.phone_iphone,
                        controller: _phoneController,
                        hintText: 'Phone Number',
                      ),
                      const SizedBox(height: 10),
                      // Birth Date.
                      InputDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now().subtract(Duration(days: (365 * 18))),
                        controller: _dateController,
                        validator: _dateValidator,
                        onDateChanged: _handleDateChanged,
                        hintText: "Birthdate",
                      ),
                      const SizedBox(height: 10),
                      // Address Postal.
                      CustomTextFormField(
                        prefixIcon: Icons.location_on_outlined,
                        controller: _addressPostalController,
                        hintText: 'Address Postal',
                      ),
                      const SizedBox(height: 20),
                      // 4) Update Profile Button.
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _hasChanged ? _onUpdateProfile : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6959C3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 5) Change Password Button.
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _onChangePassword,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom clipper to create a curved shape at the top-right corner.
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start from top-left.
    path.lineTo(0, 0);
    // Move down to bottom-left.
    path.lineTo(0, size.height * 0.75);
    final controlPoint1 = Offset(size.width * 0.3, size.height);
    final endPoint1 = Offset(size.width * 0.6, size.height * 0.6);
    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      endPoint1.dx,
      endPoint1.dy,
    );
    // Another curve to the top-right.
    final controlPoint2 = Offset(size.width * 0.8, size.height * 0.3);
    final endPoint2 = Offset(size.width, 0);
    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint2.dx,
      endPoint2.dy,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TopCurveClipper oldClipper) => false;
}
