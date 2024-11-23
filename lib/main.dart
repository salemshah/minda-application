import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minda_application/src/ui/screens/child/HomeScreen.dart';
import 'package:minda_application/src/ui/screens/child/login_child_screen.dart';
import 'package:minda_application/src/ui/screens/welcome/select_role_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  ).then((_) {
    runApp(const MindaApp());
  });
}

class MindaApp extends StatelessWidget {
  const MindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // Dynamically set designSize based on current screen size
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
        '/child': (context) => const LoginChildScreen(),
        '/home': (context) => const GameHomeScreen(),
      },
    );
  }
}

// Example of a ParentsScreen widget
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
