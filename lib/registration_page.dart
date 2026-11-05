import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  static final RegExp _nameRegex =
      RegExp(r"^(?=.{2,50}$)[A-Za-z]+(?:[ .'-][A-Za-z]+)*$");

  static final RegExp _studentIdRegex = RegExp(r'^\d{16}$');

  static final RegExp _mobileRegex = RegExp(r'^01\d{9}$');

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$');

  static final RegExp _departmentRegex =
      RegExp(r'^[A-Za-z][A-Za-z &.\-]{1,59}$');

  static final RegExp _passwordRegex =
      RegExp(r'^(?=.[A-Za-z])(?=.\d).{8,}$');

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      fillColor: const Color(0xFFF7FFFD),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      errorMaxLines: 3,
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
          'Fatflix',
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
                      Icons.person_add_alt_1,
                      size: 70,
                      color: Color(0xFF005B66),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Join Fatflix',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005B66),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Create your account to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF0F8B8D),
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration:
                          _inputDecoration('Full Name', Icons.person),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (!_nameRegex.hasMatch(input)) {
                          return 'Name can only contain letters and spaces';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _studentIdController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration:
                          _inputDecoration('Student ID', Icons.badge),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) {
                          return 'Please enter your Student ID';
                        }
                        if (!_studentIdRegex.hasMatch(input)) {
                          return 'Student ID must be 16 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration:
                          _inputDecoration('Mobile Number', Icons.phone),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (!_mobileRegex.hasMatch(input)) {
                          return 'Mobile number must be 11 digits starting with 01';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration:
                          _inputDecoration('Email Address', Icons.email),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!_emailRegex.hasMatch(input)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _departmentController,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration: _inputDecoration(
                        'Department',
                        Icons.menu_book_rounded,
                      ),
                      validator: (value) {
                        final input = value?.trim() ?? '';
                        if (input.isEmpty) {
                          return 'Please enter your department';
                        }
                        if (!_departmentRegex.hasMatch(input)) {
                          return 'Please enter a valid department name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                          return 'Please enter a password';
                        }
                        if (!_passwordRegex.hasMatch(value)) {
                          return 'Use at least 8 characters with a letter and a number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      style: const TextStyle(color: Color(0xFF29232A)),
                      decoration: _inputDecoration(
                        'Confirm Password',
                        Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF0F8B8D),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password must be at least 8 characters and include a letter and a number.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF005B66),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All fields are valid'),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Color(0xFF005B66),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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