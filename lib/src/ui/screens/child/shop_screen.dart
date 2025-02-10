import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minda_application/src/ui/screens/child/login_child_screen.dart';
import 'package:minda_application/src/ui/widgets/rive_animated_button.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _GameHomeScreen();
}

class _GameHomeScreen extends State<ShopScreen> {
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

class PortraitMode extends StatelessWidget {
  final bool isApplyHeight;
  final double mainSize;
  final double height;
  final double width;

  const PortraitMode(
      {super.key,
      required this.isApplyHeight,
      required this.mainSize,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isApplyHeight ? mainSize * .04 : 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                // 1. Stretch children vertically
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: mainSize * .050,
                        backgroundImage:
                            AssetImage('assets/images/astronaut1.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenueTitle(text: 'USERNAME'),
                          SizedBox(height: 10),
                          Container(
                            height: (mainSize * 0.028).h,
                            width: (mainSize * .15).w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.white),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/coin.png',
                            width: width * .07,
                            height: width * .07,
                          ),
                          SizedBox(width: mainSize * 0.01),
                          MenueTitle(text: '10 Mins'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/school_level.png',
                            width: width * .1,
                            height: mainSize * .1,
                          ),
                          SizedBox(width: mainSize * 0.01),
                          MenueTitle(text: '6 ème'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.gear_alt_fill,
              color: Colors.white,
              size: mainSize * .07,
              semanticLabel: 'Text to announce in accessibility modes',
            )
          ],
        ),
        /*Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RiveAnimatedButton(
                    height: mainSize * 0.1,
                    width: mainSize * 0.2,
                    conditionValue: 1,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: mainSize * 0.2,
                    conditionValue: 2,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: mainSize * 0.2,
                    conditionValue: 3,
                    onTapNavigateTo: (context) => LoginChildScreen(),
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
                width: mainSize / 2,
                height: mainSize / 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RiveAnimatedButton(
                    height: mainSize * 0.1,
                    width: mainSize * 0.2,
                    conditionValue: 1,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: mainSize * 0.2,
                    conditionValue: 2,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: mainSize * 0.2,
                    conditionValue: 3,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),*/
      ],
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isApplyHeight ? mainSize * .04 : 0),
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
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
              CircleAvatar(
                radius: mainSize * .065,
                child: Icon(
                  CupertinoIcons.gear_alt_fill,
                  size: mainSize * .07,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spac,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 1,
                    onTapNavigateTo: (context) => ShopScreen(),
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 2,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                  SizedBox(height: mainSize * 0.02),
                  RiveAnimatedButton(
                    height: mainSize * 0.10,
                    width: width * 0.15,
                    conditionValue: 3,
                    onTapNavigateTo: (context) => LoginChildScreen(),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: 150,
                        maxHeight: height - (height / 4),
                      ),
                      // color: Colors.yellow,
                      child: Image.asset(
                        'assets/icons/coins.png',
                        fit: BoxFit
                            .contain, // Optional: Adjusts the image fitting
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: 150,
                        maxHeight: height - (height / 4),
                      ),
                      // color: Colors.yellow,
                      child: Image.asset(
                        'assets/icons/coins.png',
                        fit: BoxFit
                            .contain, // Optional: Adjusts the image fitting
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxWidth: 150,
                        maxHeight: height - (height / 4),
                      ),
                      // color: Colors.yellow,
                      child: Image.asset(
                        'assets/icons/coins.png',
                        fit: BoxFit
                            .contain, // Optional: Adjusts the image fitting
                      ),
                    ),
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
