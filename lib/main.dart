import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minda_application/src/config/routes.dart';

// Import screens
import 'package:minda_application/src/ui/screens/child/child_game_home_screen.dart';
import 'package:minda_application/src/ui/screens/child/child_login_screen.dart';
import 'package:minda_application/src/ui/screens/child/child_select_character_screen.dart';
import 'package:minda_application/src/ui/screens/child/child_shop_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_dashboard_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_email_verification_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_complete_registration_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_login_screen.dart';
import 'package:minda_application/src/ui/screens/parent/parent_register_screen.dart';
import 'package:minda_application/src/ui/screens/welcome/select_role_screen.dart';

// Import utils and themes
import 'package:minda_application/src/utils/font_size.dart';
import 'package:minda_application/src/utils/themes/custom_themes/text_them.dart';

// Import ApiService, repository, and bloc
import 'package:minda_application/src/services/api_service.dart';
import 'package:minda_application/src/repositories/parent_repository.dart';
import 'package:minda_application/src/blocs/parent/parent_auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MindaApp());
  });
}

class MindaApp extends StatelessWidget {
  const MindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    FontSize(context);

    final ApiService apiService = ApiService(
        baseUrl: "http://localhost:8000/api",
        secureStorage: const FlutterSecureStorage());

    final ParentRepository parentRepository =
        ParentRepository(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ParentAuthBloc>(
          create: (context) => ParentAuthBloc(
              parentRepository: parentRepository,
              secureStorage: const FlutterSecureStorage()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final dynamicDesignSize = Size(width, height);

            return ScreenUtilInit(
              designSize: dynamicDesignSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                // return const ParentLoginScreen();
                // return const ParentCompleteRegistrationScreen();
                return const SelectRoleScreen();
              },
            );
          },
        ),
        routes: {
          Routes.parentLoginScreen: (context) => ParentLoginScreen(),
          Routes.parentRegisterScreen: (context) => ParentRegisterScreen(),
          Routes.parentEmailVerificationScreen: (context) =>
              ParentEmailVerificationScreen(),
          Routes.parentCompleteRegistrationScreen: (context) =>
              ParentCompleteRegistrationScreen(),
          Routes.parentDashboardScreen: (context) => ParentDashboardScreen(),

          // child screens
          Routes.childLoginScreen: (context) => ChildLoginScreen(),
          Routes.childGameHomeScreen: (context) => ChildGameHomeScreen(),
          Routes.childShopScreen: (context) => ChildShopScreen(),
          Routes.childSelectCharacterScreen: (context) =>
              ChildSelectCharacterScreen(),
        },
      ),
    );
  }
}
