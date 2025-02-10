import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import screens
import 'package:minda_application/src/ui/screens/child/game_home_screen.dart';
import 'package:minda_application/src/ui/screens/child/login_child_screen.dart';
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
  // Allow both portrait and landscape globally.
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
    // Initialize global font settings if needed.
    FontSize(context);

    // Create the ApiService with the base URL.
    final ApiService apiService =
        ApiService(baseUrl: "http://localhost:8000/api");

    // Create your repository instance. In this case, the ParentRepository.
    final ParentRepository parentRepository =
        ParentRepository(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        // Provide ParentAuthBloc globally. If you have more blocs, add them here.
        BlocProvider<ParentAuthBloc>(
          create: (context) =>
              ParentAuthBloc(parentRepository: parentRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // Dynamically set designSize based on the current screen size
            final dynamicDesignSize = Size(width, height);

            return ScreenUtilInit(
              designSize: dynamicDesignSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return const SelectRoleScreen();
              },
            );
          },
        ),
        routes: {
          '/parents': (context) => const ParentsScreen(),
          '/parent_register_screen': (context) => const ParentRegisterPage(),
          '/child': (context) => const LoginChildScreen(),
          '/home': (context) => const GameHomeScreen(),
        },
      ),
    );
  }
}

// Example of a ParentsScreen widget (portrait by default)
class ParentsScreen extends StatelessWidget {
  const ParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ScreenUtil for responsive sizing
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parents Screen'),
      ),
      body: Center(
        child: Text(
          'Parents Screen Content',
          style: TextStyle(fontSize: 24.sp), // Responsive text size
        ),
      ),
    );
  }
}
