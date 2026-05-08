import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final data = doc.data();

    nameController.text = data?['name'] ?? '';
    emailController.text = data?['email'] ?? '';
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}