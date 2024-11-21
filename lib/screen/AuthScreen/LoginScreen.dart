import 'package:flutter/material.dart';
import 'package:interview_task/providers/LoginPrivider.dart';
import 'package:provider/provider.dart';
import 'package:interview_task/screen/FakeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login to your account to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Username Field (replacing Email field)
              TextFormField(
                controller: _usernameController,
                focusNode: _usernameFocus,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
              ),
              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 5) {
                    return 'Password must be at least 5 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Remember Me and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "Forgot Password" logic
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign In Button
              Consumer<LoginProvider>(
                builder: (context, loginProvider, child) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginProvider.login(
                          _usernameController.text,
                          _passwordController.text,
                          context,  // Pass context to the provider method
                        ).then((_) {
                          if (loginProvider.loginModel != null) {
                            // Navigate to the next screen if login is successful
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FakeScreen()),
                            );
                          }
                        }).catchError((e) {
                          // Show error Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.9, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Divider with "Or"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 24),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    Colors.blue,
                    Icons.facebook,
                        () => _handleSocialLogin(context, "Facebook"),
                  ),
                  _buildSocialButton(
                    Colors.red,
                    Icons.g_mobiledata_rounded,
                        () => _handleSocialLogin(context, "Google"),
                  ),
                  _buildSocialButton(
                    Colors.black,
                    Icons.apple,
                        () => _handleSocialLogin(context, "Apple"),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Sign Up Prompt
              const Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Redesigned Social Button
  Widget _buildSocialButton(Color color, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  // Handle social login and show Snackbar, then navigate to FakeScreen
  void _handleSocialLogin(BuildContext context, String platform) async {
    final snackBar = SnackBar(
      content: Text('$platform login successful!'),
      backgroundColor: Colors.green, // Green color for success
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Simulate a delay before navigating to FakeScreen
    await Future.delayed(const Duration(seconds: 1));

    // Navigate to FakeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FakeScreen()),
    );
  }
}
