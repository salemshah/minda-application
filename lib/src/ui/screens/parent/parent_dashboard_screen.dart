import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';

import '../../../blocs/parent/parent_auth_event.dart';
import '../../../blocs/parent/parent_auth_state.dart';
import '../../../config/routes.dart';
import '../../common/navigate_with_oriantation.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ParentAuthBloc>().add(ParentGetProfileRequested());
  }

  void _logout() {
    BlocProvider.of<ParentAuthBloc>(context).add(ParentLogoutRequested());
  }

  List<Widget> _buildProfileInfo(ParentAuthState state) {
    if (state is ParentGetProfileSuccess) {
      final parent = state.parent;

      return [
        Text(parent.firstName),
        Text(parent.lastName),
        Text(parent.email),
        Text(parent.phoneNumber ?? "No available"),
        Text(parent.birthDate.toString()),
        Text(parent.addressPostal ?? "No available"),
      ];
    }
    return [Text("Loading...")];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentAuthBloc, ParentAuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          navigateWithOrientation(
            context: context,
            orientations: [DeviceOrientation.portraitUp],
            navigationType: NavigationType.pushNamedAndRemoveUntil,
            routeName: Routes.parentLoginScreen,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Parent Dashboard"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome"),
                ..._buildProfileInfo(state),
                ElevatedButton(
                  onPressed: _logout,
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
