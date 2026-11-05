import 'package:final_project_debojyoti_64_g_306/homepage.dart';
import 'package:final_project_debojyoti_64_g_306/registration_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _idOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$');

  static final RegExp _studentIdRegex = RegExp(r'^\d{16}$');

  @override
  void dispose() {
    _idOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF005B66)),
      prefixIcon: Icon(icon, color: const Color(0xFF0F8B8D)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color.fromARGB(255, 248, 254, 255),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB8DEDA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00A6A6), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4F5F2),
      appBar: AppBar(
        title: const Text(
          'FatFlix',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF005B66),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.movie_filter_rounded,
                      size: 75,
                      color: Color(0xFF005B66),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to Fatflix',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005B66),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login to continue to Fatflix',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0F8B8D),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _idOrEmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration: _inputDecoration(
                        'Student ID or Email',
                        Icons.person,
                      ),
                      validator: (value) {
                        final input = value?.trim() ?? '';

                        if (input.isEmpty) {
                          return 'Please enter your Student ID or Email';
                        }

                        if (input.contains('@')) {
                          if (!_emailRegex.hasMatch(input)) {
                            return 'Please enter a valid email';
                          }
                        } else if (!_studentIdRegex.hasMatch(input)) {
                          return 'Student ID must be 16 digits';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration: _inputDecoration(
                        'Password',
                        Icons.lock,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF0F8B8D),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005B66),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF29232A),
                            fontSize: 14,
                          ),
                        ),
                        _HoverLink(
                          text: 'Register here',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverLink({required this.text, required this.onTap});

  @override
  State<_HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<_HoverLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          offset: _hovered ? const Offset(0, -0.2) : Offset.zero,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF005B66),
              decoration:
                  _hovered ? TextDecoration.underline : TextDecoration.none,
              decorationColor: const Color(0xFF005B66),
              shadows: _hovered
                  ? [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}