import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/provider/app_provider.dart';
import 'package:sample_app/screens/home_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool isButtonVissible = true;
  void clearText() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: isButtonVissible
            ? const SizedBox()
            : BackButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    )),
              ),
        title: Text(isButtonVissible ? 'Login' : "SignUp"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onSaved: (newValue) {
                    emailController.text = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onSaved: (newValue) {
                    passwordController.text = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                isButtonVissible
                    ? ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          if (_loginFormKey.currentState!.validate()) {
                            _loginFormKey.currentState!.save();
                          }
                          dataProvider
                              .signInWithEmailAndPassword(email, password)
                              .then((user) async {
                            if (user != null) {
                              // Navigate to home or dashboard screen after successful login
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ));
                            } else {
                              // Show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(dataProvider.errorMessage)));
                            }
                          });
                        },
                        child: const Text('Login'),
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                !isButtonVissible
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't you have an account?"),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  isButtonVissible = false;
                                });
                              },
                              child: const Text("SignUp"))
                        ],
                      ),
                isButtonVissible
                    ? const SizedBox()
                    : ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          if (_loginFormKey.currentState!.validate()) {
                            _loginFormKey.currentState!.save();
                          }
                          dataProvider
                              .registerWithEmailAndPassword(email, password)
                              .then((user) {
                            if (user != null) {
                              // Registration successful, navigate back to login screen
                              // Navigator.pop(context);
                              setState(() {
                                isButtonVissible = true;
                              });
                              clearText();
                            } else {
                              // Show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(dataProvider.errorMessage)));
                              log("failed ");
                            }
                          });
                        },
                        child: const Text('Create an Account'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
