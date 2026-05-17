import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import 'edit_profile.dart';
import 'login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  final TextEditingController oldPasswordController =
  TextEditingController();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  Future<void> changePassword() async {

    try {

      User? user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      String oldPassword =
      oldPasswordController.text.trim();

      String newPassword =
      newPasswordController.text.trim();

      String confirmPassword =
      confirmPasswordController.text.trim();

      if (oldPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmPassword.isEmpty) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
            Text("Please fill all fields"),
          ),
        );

        return;
      }

      if (newPassword != confirmPassword) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
            Text("Passwords do not match"),
          ),
        );

        return;
      }

      if (newPassword.length < 6) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Password must be at least 6 characters",
            ),
          ),
        );

        return;
      }

      AuthCredential credential =
      EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(
        credential,
      );

      await user.updatePassword(
        newPassword,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Password updated successfully",
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String message =
          "Something went wrong";

      if (e.code == 'wrong-password') {

        message =
        "Old password is incorrect";

      } else if (e.code ==
          'weak-password') {

        message =
        "New password is too weak";

      } else if (e.code ==
          'requires-recent-login') {

        message =
        "Please login again and retry";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void openChangePasswordDialog() {

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (_) {

        final isDark =
            Theme.of(context).brightness ==
                Brightness.dark;

        return AlertDialog(

          backgroundColor:
          isDark
              ? const Color(0xFF161B22)
              : Colors.white,

          title:
          const Text("Change Password"),

          content: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller:
                  oldPasswordController,

                  obscureText: true,

                  decoration:
                  const InputDecoration(
                    labelText:
                    "Old Password",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller:
                  newPasswordController,

                  obscureText: true,

                  decoration:
                  const InputDecoration(
                    labelText:
                    "New Password",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller:
                  confirmPasswordController,

                  obscureText: true,

                  decoration:
                  const InputDecoration(
                    labelText:
                    "Confirm Password",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.pop(context),

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: changePassword,
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
  }

  Widget buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final cardColor =
    isDark
        ? const Color(0xFF161B22)
        : Colors.white;

    final iconColor =
        color ??
            const Color(0xFF4FC3F7);

    final primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    final secondaryText =
    isDark
        ? Colors.white60
        : Colors.black54;

    return Container(

      margin:
      const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color:
          isDark
              ? Colors.white10
              : Colors.black12,
        ),
      ),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor:
          iconColor.withOpacity(0.12),

          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        title: Text(
          title,

          style: TextStyle(
            color: primaryText,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        subtitle: Text(
          subtitle,

          style: TextStyle(
            color: secondaryText,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),

        onTap: onTap,
      ),
    );
  }

  Widget buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final cardColor =
    isDark
        ? const Color(0xFF161B22)
        : Colors.white;

    final primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    final secondaryText =
    isDark
        ? Colors.white60
        : Colors.black54;

    return Container(

      margin:
      const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color:
          isDark
              ? Colors.white10
              : Colors.black12,
        ),
      ),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor:
          const Color(0xFF4FC3F7)
              .withOpacity(0.12),

          child: const Icon(
            Icons.dark_mode_outlined,
            color:
            Color(0xFF4FC3F7),
          ),
        ),

        title: Text(
          title,

          style: TextStyle(
            color: primaryText,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        subtitle: Text(
          subtitle,

          style: TextStyle(
            color: secondaryText,
          ),
        ),

        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor:
          const Color(0xFF4FC3F7),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    final name =
        user?.displayName ?? "User";

    final email =
        user?.email ?? "";

    final initials =
    name.isNotEmpty
        ? name[0].toUpperCase()
        : "U";

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          "Settings",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child: ListView(
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
                BorderRadius.circular(22),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 30,

                    backgroundColor:
                    Colors.white24,

                    child: Text(
                      initials,

                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          name,

                          style:
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        Text(
                          email,

                          style:
                          const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            buildTile(
              context: context,

              icon:
              Icons.person_outline,

              title: "Edit Profile",

              subtitle:
              "Update your name and email",

              onTap: () async {

                await Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                    const EditProfileScreen(),
                  ),
                );

                await FirebaseAuth.instance
                    .currentUser
                    ?.reload();

                setState(() {});
              },
            ),

            buildTile(
              context: context,

              icon:
              Icons.lock_outline,

              title:
              "Change Password",

              subtitle:
              "Update your password",

              onTap:
              openChangePasswordDialog,
            ),

            buildSwitchTile(
              context: context,

              icon:
              Icons.dark_mode_outlined,

              title: "Dark Mode",

              subtitle:
              darkModeEnabled
                  ? "Dark theme enabled"
                  : "Light theme enabled",

              value:
              darkModeEnabled,

              onChanged: (value) {

                setState(() {
                  darkModeEnabled =
                      value;
                });

                MyApp.of(context)
                    .updateTheme(value);
              },
            ),

            buildTile(
              context: context,

              icon: Icons.logout,

              title: "Logout",

              subtitle:
              "Sign out from app",

              color: Colors.red,

              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}