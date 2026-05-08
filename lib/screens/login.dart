import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController nameController =
  TextEditingController();

  bool isSignup = false;

  bool obscurePassword = true;

  bool loading = false;

  bool isValidEmail(String email) {

    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  bool isValidPassword(String password) {

    return RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$',
    ).hasMatch(password);
  }

  Future<void> handleAuth() async {

    String email =
    emailController.text.trim();

    String password =
    passwordController.text.trim();

    String name =
    nameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        (isSignup && name.isEmpty)) {

      showMessage(
        "Please fill all fields",
      );

      return;
    }

    if (!isValidEmail(email)) {

      showMessage(
        "Enter valid email address",
      );

      return;
    }

    if (!isValidPassword(password)) {

      showMessage(
        "Password must contain uppercase, lowercase and number",
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      if (isSignup) {

        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseAuth.instance
            .currentUser!
            .updateDisplayName(name);

      } else {

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const MainNavScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      showMessage(
        e.message ?? "Authentication failed",
      );

    } catch (e) {

      showMessage(
        e.toString(),
      );
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> forgotPassword() async {

    String email =
    emailController.text.trim();

    if (email.isEmpty) {

      showMessage(
        "Enter email first",
      );

      return;
    }

    if (!isValidEmail(email)) {

      showMessage(
        "Enter valid email",
      );

      return;
    }

    try {

      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: email,
      );

      showMessage(
        "Password reset email sent",
      );

    } catch (e) {

      showMessage(
        e.toString(),
      );
    }
  }

  void showMessage(String message) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  InputDecoration fieldDecoration(
      String hint,
      IconData icon, {
        Widget? suffixIcon,
      }) {

    return InputDecoration(

      hintText: hint,

      prefixIcon: Icon(
        icon,
        color:
        const Color(0xFF4FC3F7),
      ),

      suffixIcon: suffixIcon,

      filled: true,

      fillColor: Colors.white,

      border: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(16),

        borderSide: BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(16),

        borderSide:
        const BorderSide(
          color: Colors.black12,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(16),

        borderSide:
        const BorderSide(
          color: Color(0xFF4FC3F7),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      body: Center(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Container(

            padding:
            const EdgeInsets.all(24),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(24),

              border: Border.all(
                color: Colors.black12,
              ),
            ),

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              children: [

                Container(

                  height: 90,
                  width: 90,

                  decoration: BoxDecoration(

                    shape:
                    BoxShape.circle,

                    gradient:
                    const LinearGradient(
                      colors: [
                        Color(0xFF4FC3F7),
                        Color(0xFF7C4DFF),
                      ],
                    ),
                  ),

                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 44,
                  ),
                ),

                const SizedBox(height: 24),

                Text(

                  isSignup
                      ? "Create Account"
                      : "Welcome Back",

                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(

                  isSignup
                      ? "Signup to continue"
                      : "Login to your wallet",

                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                if (isSignup) ...[

                  TextField(

                    controller:
                    nameController,

                    decoration:
                    fieldDecoration(
                      "Full Name",
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 18),
                ],

                TextField(

                  controller:
                  emailController,

                  keyboardType:
                  TextInputType.emailAddress,

                  decoration:
                  fieldDecoration(
                    "Email",
                    Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(

                  controller:
                  passwordController,

                  obscureText:
                  obscurePassword,

                  decoration:
                  fieldDecoration(

                    "Password",

                    Icons.lock_outline,

                    suffixIcon:
                    IconButton(

                      icon: Icon(

                        obscurePassword
                            ? Icons
                            .visibility_off
                            : Icons.visibility,
                      ),

                      onPressed: () {

                        setState(() {
                          obscurePassword =
                          !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (!isSignup)

                  Align(

                    alignment:
                    Alignment.centerRight,

                    child: TextButton(

                      onPressed:
                      forgotPassword,

                      child: const Text(
                        "Forgot Password?",
                      ),
                    ),
                  ),

                const SizedBox(height: 14),

                SizedBox(

                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(
                        0xFF4FC3F7,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    onPressed:
                    loading
                        ? null
                        : handleAuth,

                    child: loading

                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )

                        : Text(

                      isSignup
                          ? "Signup"
                          : "Login",

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(

                  onPressed: () {

                    setState(() {
                      isSignup = !isSignup;
                    });
                  },

                  child: Text(

                    isSignup
                        ? "Already have account? Login"
                        : "Create Account",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}