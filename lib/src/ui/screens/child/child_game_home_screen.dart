import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minda_application/src/ui/screens/child/child_shop_screen.dart';
import 'package:minda_application/src/ui/widgets/rive_animated_button.dart';

import '../../../config/routes.dart';

class ChildGameHomeScreen extends StatefulWidget {
  const ChildGameHomeScreen({super.key});

  @override
  State<ChildGameHomeScreen> createState() => _ChildGameHomeScreen();
}

class _ChildGameHomeScreen extends State<ChildGameHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double topPadding = mediaQuery.padding.top;
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    const double statusBarThreshold = 20.0;
    final bool isApplyHeight = isLandscape && topPadding < statusBarThreshold;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    bool landscape = currentOrientation == Orientation.landscape;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
        double height = constraint.maxHeight;
        double width = constraint.maxWidth;
        double mainSize = landscape ? height : width;

        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/background/space_background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  !landscape
                      ? PortraitMode(
                          isApplyHeight: isApplyHeight,
                          mainSize: mainSize,
                          height: height,
                          width: width,
                        )
                      : LandscapeMode(
                          isApplyHeight: isApplyHeight,
                          mainSize: mainSize,
                          width: width,
                          height: height,
                        )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class LandscapeMode extends StatelessWidget {
  final bool isApplyHeight;
  final double mainSize;
  final double width;
  final double height;

  const LandscapeMode(
      {super.key,
      required this.isApplyHeight,
      required this.mainSize,
      required this.width,
      required this.height});

  void showCenteredModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: Colors.deepPurpleAccent, //

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'PARAMÈTRES',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 5, bottom: 30, right: 30),
                child: SettingsScreen(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isApplyHeight ? mainSize * .04 : 0),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: mainSize * .065,
                      backgroundImage:
                          AssetImage('assets/images/astronaut1.png'),
                    ),
                    SizedBox(width: width * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MenueTitle(text: 'USERNAME'),
                        SizedBox(height: 10),
                        Container(
                          height: mainSize * 0.035,
                          width: width * .15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.01),
                    Image.asset(
                      'assets/icons/coin.png',
                      width: height * .1,
                      height: height * .1,
                    ),
                    SizedBox(width: width * 0.01),
                    MenueTitle(text: '10 Mins'),
                    SizedBox(width: width * 0.01),
                    Image.asset(
                      'assets/icons/school_level.png',
                      width: width * .1,
                      height: mainSize * .1,
                    ),
                    SizedBox(width: mainSize * 0.01),
                    MenueTitle(text: '6 ème'),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showCenteredModal(context);
                },
                child: CircleAvatar(
                  radius: mainSize * .065,
                  child: Icon(
                    CupertinoIcons.gear_alt_fill,
                    size: mainSize * .07,

                    // semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 1,
                    routeName: Routes.childLoginScreen,
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 2,
                    routeName: Routes.childShopScreen,
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 3,
                    routeName: Routes.childShopScreen,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/background/space_background.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 4),
                ),
                width: width / 2,
                height: mainSize / 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 1,
                    routeName: Routes.childShopScreen,
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 2,
                    routeName: Routes.childShopScreen,
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 3,
                    routeName: Routes.childShopScreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MenueTitle extends StatelessWidget {
  final String text;

  const MenueTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State for checkboxes
  final Map<String, bool> _settings = {
    "Musique": false,
    "Son": false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // List of settings with checkboxes
          ..._settings.keys.map((key) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _settings[key] = !_settings[key]!;
                    });
                  },
                  child: ListTile(
                    leading: _getIconForSetting(key),
                    title: Text(
                      key,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: Checkbox(
                      value: _settings[key],
                      activeColor: Colors.blueAccent,
                      onChanged: (bool? value) {
                        setState(() {
                          _settings[key] = value!;
                        });
                      },
                    ),
                  ),
                ),
                Divider(), // Divider between items
              ],
            );
          }),

          // Quitter button (without a checkbox)
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the screen
            },
            child: ListTile(
              leading: Icon(Icons.close, color: Colors.red, size: 28),
              title: Text(
                "Quitter",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to return icons for each setting
  Widget _getIconForSetting(String key) {
    switch (key) {
      case "Musique":
        return Icon(Icons.music_note, color: Colors.blue, size: 28);
      case "Son":
        return Icon(Icons.volume_up, color: Colors.blue, size: 28);
      default:
        return Icon(Icons.settings, color: Colors.grey, size: 28);
    }
  }
}
