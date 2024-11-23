import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:minda_application/src/ui/screens/child/game_home_screen.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final List<Map<String, dynamic>> characters = [
    {
      'id': 1,
      'name': 'Nebula Frostfire',
      'isLocked': false,
      'assetPath': 'assets/images/astronaut1.png',
      'order': 2,
      'description': 'A fearless explorer of the frozen cosmos.',
    },
    {
      'id': 2,
      'name': 'Captain Starfall',
      'isLocked': false,
      'assetPath': 'assets/images/astronaut1.png',
      'order': 1,
      'description': 'Leader of the intergalactic fleet.',
    },
    {
      'id': 3,
      'name': 'Nova Stratos',
      'isLocked': true,
      'assetPath': 'assets/images/astronaut1.png',
      'order': 3,
      'description': 'Master of stellar navigation.',
    },
    {
      'id': 4,
      'name': 'Galaxy Voyager',
      'isLocked': true,
      'assetPath': 'assets/images/astronaut1.png',
      'order': 4,
      'description': 'Explorer of uncharted galaxies.',
    },
    {
      'id': 5,
      'name': 'Cosmic Phantom',
      'isLocked': true,
      'assetPath': 'assets/images/astronaut1.png',
      'order': 5,
      'description': 'A mysterious figure from the depths of space.',
    },
    {
      'id': 6,
      'name': 'Starshard Hunter',
      'isLocked': true,
      'assetPath': 'assets/images/astronaut1.png',
      'order': 6,
      'description': 'Collector of rare cosmic artifacts.',
    },
  ]..sort((a, b) => a['order'].compareTo(b['order']));

  int? selectedCharacterIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          double height = constraint.maxHeight;
          double width = constraint.maxWidth;
          return Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 1),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background/space_background2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Choisis ton perso',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: characters.length,
                          itemBuilder: (context, index) {
                            return CharacterCard(
                              characterName: characters[index]['name'],
                              isLocked: characters[index]['isLocked'],
                              assetPath: characters[index]['assetPath'],
                              height: height,
                              width: width,
                              isSelected: selectedCharacterIndex == index,
                              onTap: () {
                                if (!characters[index]['isLocked']) {
                                  setState(() {
                                    selectedCharacterIndex = index;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GameHomeScreen()));
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final String characterName;
  final bool isLocked;
  final String assetPath;
  final double height;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.characterName,
    required this.isLocked,
    required this.assetPath,
    required this.height,
    required this.width,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.transparent,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(assetPath),
                  ),
                  if (isLocked)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              characterName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
