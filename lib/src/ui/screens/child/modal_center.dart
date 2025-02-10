import 'package:flutter/material.dart';

class ModalCenter extends StatelessWidget {
  const ModalCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Centered Modal Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Centered Modal Example'),
          ),
          body: Center(
            child: ElevatedButton(
              child: Text('Show Custom Modal'),
              onPressed: () {
                showCustomCenteredModal(context);
              },
            ),
          ),
        ));
  }

  void showCustomCenteredModal(BuildContext context) {

  }
}
