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

  final nameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    if (user == null) return;

    final doc =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final data = doc.data();

    setState(() {

      nameController.text =
          data?['name'] ??
              user?.displayName ??
              '';

      emailController.text =
          data?['email'] ??
              user?.email ??
              '';
    });
  }

  Future<void> saveProfile() async {

    if (user == null) return;

    final name =
    nameController.text.trim();

    final email =
    emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Please fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'name': name,
        'email': email,
      }, SetOptions(merge: true));

      await user!.updateDisplayName(name);

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
            Text("Profile Updated"),
          ),
        );

        Navigator.pop(context, true);
      }

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }

    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {

    return TextField(

      controller: controller,

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(icon),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),

          borderSide: const BorderSide(
            color: Colors.black12,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(16),

          borderSide: const BorderSide(
            color: Color(0xFF4FC3F7),
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final name =
    nameController.text.isEmpty
        ? "User"
        : nameController.text;

    final initials =
    name[0].toUpperCase();

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          "Edit Profile",

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(

                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF4FC3F7),
                    Color(0xFF7C4DFF),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(
                    22),
              ),

              child: Column(
                children: [

                  CircleAvatar(
                    radius: 42,

                    backgroundColor:
                    Colors.white24,

                    child: Text(
                      initials,

                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    name,

                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    emailController.text,

                    style:
                    const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            inputField(
              label: "Full Name",
              controller: nameController,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 18),

            inputField(
              label: "Email",
              controller: emailController,
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 28),

            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : saveProfile,

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(
                      0xFF4FC3F7),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        16),
                  ),
                ),

                child:
                isLoading
                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )
                    : const Text(
                  "Save Profile",

                  style:
                  TextStyle(
                    color:
                    Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}