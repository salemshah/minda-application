import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/ui/screens/parent/parent_profile_screen.dart';

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
  int _selectedIndex = 0;

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
        Text('First Name: ${parent.firstName}'),
        Text('Last Name: ${parent.lastName}'),
        Text('Email: ${parent.email}'),
        Text('Phone: ${parent.phoneNumber ?? "No available"}'),
        Text('Birth Date: ${parent.birthDate.toString()}'),
        Text('Address: ${parent.addressPostal ?? "No available"}'),
      ];
    }
    return [const Text("Loading...")];
  }

  // Handle item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        // Define your pages
        final List<Widget> _pages = <Widget>[
          Center(
              child: Center(
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
          )),
          Center(
            child: Text(
              'Camera Page',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Center(
            child: ParentProfileScreen(),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text("Dashboard"),
          ),
          body: SafeArea(child: _pages[_selectedIndex]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.deepPurple,
            // Color for selected item label and icon
            unselectedItemColor: Color(0xFFADA1F3),
            // Color for unselected labels
            selectedIconTheme: const IconThemeData(color: Colors.deepPurple),
            unselectedIconTheme: const IconThemeData(color: Color(0xFFB7ABFF)),
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.child_care_rounded),
                label: 'Child',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }
}
