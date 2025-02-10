import 'package:flutter/material.dart';
import 'package:minda_application/src/ui/screens/child/login_child_screen.dart';
import 'package:rive/rive.dart';

class RiveAnimatedButton extends StatelessWidget {
  final double height;
  final double width;
  final String assetPath;
  final String stateMachineName;
  final double conditionValue;
  final Alignment alignment;
  final BoxFit fit;
  final WidgetBuilder onTapNavigateTo;

  const RiveAnimatedButton({
    super.key,
    required this.height,
    required this.width,
    required this.conditionValue,
    required this.onTapNavigateTo,
    this.assetPath = 'assets/rive_files/buttons.riv',
    this.stateMachineName = 'button_sm',
    this.alignment = Alignment.centerLeft,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTapUp: (detail) {
          Navigator.push(context, MaterialPageRoute(builder: onTapNavigateTo));
        },
        child: RiveAnimation.asset(
          assetPath,
          stateMachines: [stateMachineName],
          alignment: alignment,
          fit: fit,
          onInit: (Artboard artboard) {
            final controller = StateMachineController.fromArtboard(
              artboard,
              stateMachineName,
            );
            if (controller == null) return;
            artboard.addController(controller);
            controller.findSMI<SMINumber>("condition")?.change(conditionValue);
          },
        ),
      ),
    );
  }
}
