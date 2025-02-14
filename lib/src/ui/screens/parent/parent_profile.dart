import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _onLogoutPressed() {
    // Handle logout logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a leading back arrow
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // 1) Avatar, Name, and Email
            Row(
              children: [
                // Circular Avatar
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Replace with your asset or network image
                  ),
                ),
                const SizedBox(width: 16),
                // Name and Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Bagja Alfatih',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'bagjaalfatih17@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 2) List of Profile Menu Items
            Expanded(
              child: ListView(
                children: [
                  // My Profile
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('My Profile'),
                    onTap: () {
                      // Navigate to My Profile page
                    },
                  ),
                  // Settings
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    onTap: () {
                      // Navigate to Settings
                    },
                  ),
                  // Notifications
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Notifications'),
                    onTap: () {
                      // Navigate to Notifications
                    },
                  ),
                  // Transaction History
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: const Text('Transaction History'),
                    onTap: () {
                      // Navigate to Transaction History
                    },
                  ),
                  // FAQ
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('FAQ'),
                    onTap: () {
                      // Navigate to FAQ
                    },
                  ),
                  // About App
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About App'),
                    onTap: () {
                      // Navigate to About page
                    },
                  ),

                  const Divider(),

                  // 3) Logout
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: _onLogoutPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
