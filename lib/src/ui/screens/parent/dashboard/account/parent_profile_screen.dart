import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/common/navigate_with_oriantation.dart';

import '../../../../../blocs/parent/parent_auth_bloc.dart';
import '../../../../../blocs/parent/parent_auth_event.dart';
import '../../../../../config/routes.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  void _onLogoutPressed() {
    BlocProvider.of<ParentAuthBloc>(context).add(ParentLogoutRequested());
    navigateWithOrientation(
      context: context,
      orientations: [DeviceOrientation.portraitUp],
      navigationType: NavigationType.pushNamedAndRemoveUntil,
      routeName: Routes.parentLoginScreen,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ParentAuthBloc>().add(ParentGetProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentAuthBloc, ParentAuthState>(
        builder: (context, state) {
      // if (state is ParentLogoutSuccess) {
      //
      // }
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  // Circular Avatar
                  CircleAvatar(
                    radius: 36,
                  ),
                  const SizedBox(width: 16),
                  // Name and Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (state is ParentGetProfileSuccess)
                              ? '${state.parent.firstName.toUpperCase()} ${state.parent.lastName.toUpperCase()}'
                              : '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (state is ParentGetProfileSuccess)
                              ? state.parent.email
                              : '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2) List of Profile Menu Items
              Expanded(
                child: ListView(
                  children: [
                    // My Profile
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('My Profile'),
                      onTap: () {
                        navigateWithOrientation(
                          context: context,
                          orientations: [DeviceOrientation.portraitUp],
                          navigationType: NavigationType.pushNamed,
                          routeName: Routes.parentUpdateProfileScreen,
                        );
                      },
                    ),
                    // Settings
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      onTap: () {
                        // Navigate to Settings
                      },
                    ),
                    // Notifications
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      onTap: () {
                        // Navigate to Notifications
                      },
                    ),
                    // Transaction History
                    ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: const Text('Transaction History'),
                      onTap: () {
                        // Navigate to Transaction History
                      },
                    ),
                    // FAQ
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('FAQ'),
                      onTap: () {
                        // Navigate to FAQ
                      },
                    ),
                    // About App
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About App'),
                      onTap: () {
                        // Navigate to About page
                      },
                    ),

                    const Divider(),

                    // 3) Logout
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: _onLogoutPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
