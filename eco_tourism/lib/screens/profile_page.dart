import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_tourism/widgets/text_box.dart';
import 'package:eco_tourism/forms/login_page.dart'; // Assuming you have a login screen

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    // Check if currentUser is null, if so, navigate to login screen
    if (currentUser == null) {
      return const LoginPage(); // Navigate to login screen if not logged in
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Icon(Icons.person, size: 72),
          const SizedBox(
            height: 10,
          ),
          if (currentUser != null)
            Text(
              currentUser!.email ?? 'Email not available',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'My Details',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextBox(
            text: 'Lameckwh',
            sectionName: 'Username',
            onPressed: () => editField('username'),
          ),
          TextBox(
            text:
                'Saleor, on the other hand, provides a flexible and customizable foundation for building e-commerce applications but requires developers to write code to tailor the platform to specific business requirements, integrate with external systems, and extend its functionality.',
            sectionName: 'Bio',
            onPressed: () => editField('username'),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'My Bookings',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
