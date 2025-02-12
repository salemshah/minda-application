import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/ui/screens/parent/parent_login_screen.dart';

import '../../../blocs/parent/parent_auth_event.dart';
import '../../../blocs/parent/parent_auth_state.dart';
import '../../common/orientation_wrapper.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  void _logout() {
    BlocProvider.of<ParentAuthBloc>(context).add(ParentLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    print("okkkk");
    return OrientationWrapper(
      orientations: const [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
      child: BlocListener<ParentAuthBloc, ParentAuthState>(
        listener: (context, state) {
          print("Auth");
          if (state is AuthUnauthenticated) {
            print("Not auth");

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentLoginScreen(),
              ),
              (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Parent Dashboard"),
          ),
          body: Center(
            child: Column(
              children: [
                Text("Welcome"),
                ElevatedButton(onPressed: _logout, child: Text("Logout"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
