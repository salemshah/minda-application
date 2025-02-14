import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_state.dart';
import 'package:minda_application/src/ui/common/orientation_wrapper.dart';
import 'package:minda_application/src/ui/screens/child/child_login_screen.dart';
import 'package:minda_application/src/config/routes.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_event.dart';

import '../../common/navigate_with_oriantation.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force landscape mode.
    return OrientationWrapper(
      orientations: const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      resetOnDispose: false,
      child: BlocListener<ParentAuthBloc, ParentAuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {

            navigateWithOrientation(
              context: context,
              orientations: [DeviceOrientation.portraitUp],
              navigationType: NavigationType.pushNamedAndRemoveUntil,
              routeName: Routes.parentWelcomeScreen,
            );

            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   Routes.parentLoginScreen,
            //   (route) => false,
            // );
          } else if (state is AuthAuthenticated) {

            navigateWithOrientation(
              context: context,
              orientations: [DeviceOrientation.portraitUp],
              navigationType: NavigationType.pushNamedAndRemoveUntil,
              routeName: Routes.parentDashboardScreen,
            );

            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   Routes.parentDashboardScreen,
            //   (route) => false,
            // );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            double height = constraints.maxHeight;
            double width = constraints.maxWidth;
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background/space_background.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "PARENTS" button
                      SizedBox(
                        width: (width * 0.3).w, // Adjusted for landscape
                        height: (height * 0.08).h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            context
                                .read<ParentAuthBloc>()
                                .add(CheckParentTokenExpiration());
                          },
                          child: Text(
                            'PARENTS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      // "ENFANTS" button
                      SizedBox(
                        width: (width * 0.3).w,
                        height: (height * 0.08).h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {

                            navigateWithOrientation(
                              context: context,
                              orientations: [
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ],
                              navigationType: NavigationType.pushNamedAndRemoveUntil,
                              routeName: Routes.childLoginScreen,
                            );

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ChildLoginScreen(),
                            //   ),
                            // );
                          },
                          child: Text(
                            'ENFANTS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
