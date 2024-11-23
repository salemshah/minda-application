
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GameHomeScreen extends StatelessWidget {
  const GameHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double topPadding = mediaQuery.padding.top;
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Define a threshold to determine if the status bar is present
    const double statusBarThreshold = 20.0;

    // Determine whether to apply the margin
    final bool applyMargin = isLandscape && topPadding < statusBarThreshold;

    print("sssssss" + applyMargin.toString());
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
        double height = constraint.maxHeight;
        double width = constraint.maxWidth;
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
                  Column(
                    children: [
                      SizedBox(height: height * .04),
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
                                    radius: height * .065,
                                    backgroundImage: AssetImage(
                                        'assets/images/astronaut1.png'),
                                  ),
                                  SizedBox(width: width * 0.01),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
// Adjust content alignment
                                    children: [
                                      Text(
                                        'USERNAME',
                                        style: TextStyle(
                                          fontSize: 16.spMax,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: height * 0.035,
                                        width: width * .15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          border:
                                          Border.all(color: Colors.white),
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
                                  Text(
                                    '10 Mins',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.01),
                                  Image.asset(
                                    'assets/icons/school_level.png',
                                    width: height * .1,
                                    height: height * .1,
                                  ),
                                  SizedBox(width: width * 0.01),
                                  Text(
                                    '6 ème',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            CircleAvatar(
                              radius: height * .065,
                              child: Icon(
                                CupertinoIcons.gear_alt_fill,
                                size: height * .07,
                                semanticLabel:
                                'Text to announce in accessibility modes',
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
                                GameOptionButton(
                                    icon: Icons.person,
                                    label: 'AVATAR',
                                    onPressed: () {}),
                                GameOptionButton(
                                    icon: Icons.store,
                                    label: 'SHOP',
                                    onPressed: () {}),
                                GameOptionButton(
                                    icon: Icons.assignment,
                                    label: 'QUETES',
                                    onPressed: () {}),
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
                                border:
                                Border.all(color: Colors.white, width: 4),
                              ),
                              width: height / 2,
                              height: height / 2,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GameOptionButton(
                                    icon: Icons.chat,
                                    label: 'AMIS',
                                    onPressed: () {}),
                                GameOptionButton(
                                    icon: Icons.group,
                                    label: 'EQUIPE',
                                    onPressed: () {}),
                                GameOptionButton(
                                    icon: Icons.info,
                                    label: 'INFOS',
                                    onPressed: () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class GameOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const GameOptionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
