import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';
import 'package:final_project_debojyoti_64_g_306/utils/validators.dart';
import 'package:final_project_debojyoti_64_g_306/widget/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Stop the spinner and tell the user exactly what went wrong.
  void _fail(String text) {
    if (!mounted) return;
    _showMessage(text);
    setState(() {
      _isLoading = false;
    });
  }

  String _authMessage(FirebaseAuthException e) {
    final code = e.code;
    if (code == 'email-already-in-use') return "This email is already registered.";
    if (code == 'weak-password') return "Password is too weak.";
    if (code == 'invalid-email') return "That email address is not valid.";
    if (code == 'network-request-failed') return "No internet connection.";
    if (code == 'operation-not-allowed') {
      return "Email/Password sign-in is NOT enabled. In the Firebase console open "
          "Authentication > Sign-in method and enable Email/Password.";
    }
    return "Registration failed [$code]: ${e.message}";
  }

  Future<void> register() async {
    setState(() {
      _isLoading = true;
    });

    // 1) Create the login. Firebase Auth hashes and stores the password.
    UserCredential cred;
    try {
      cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          )
          .timeout(const Duration(seconds: 20));
    } on FirebaseAuthException catch (e) {
      _fail(_authMessage(e));
      return;
    } catch (e) {
      _fail("Could not create the account (no response). Check your internet. $e");
      return;
    }

    // 2) Save the extra details (NO password) in Firestore, 'users' collection.
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'studentId': _idController.text.trim(),
            'phone': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'rickrollCount': 0,
          })
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      // Roll back the half-finished account so the user can simply try again.
      try {
        await cred.user!.delete();
      } catch (_) {}
      _fail(
        "Profile could not be saved, so registration was cancelled. "
        "Check that the Firestore database exists and the rules are published. ($e)",
      );
      return;
    }

    if (!mounted) return;
    _showMessage("Registered successfully!");  // Firebase already signed the user in, so AuthGate is showing HomePage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: kMaroon,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 350,
            child: Card(
              color: kPink,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Register Form",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.text,
                        labelText: "First Name",
                        hintText: "Enter first name",
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) => Validators.name(value, "First name"),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.text,
                        labelText: "Last Name",
                        hintText: "Enter last name",
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (value) => Validators.name(value, "Last name"),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _idController,
                        keyboardType: TextInputType.number,
                        labelText: "Student ID",
                        hintText: "Enter ID",
                        prefixIcon: const Icon(Icons.badge),
                        validator: (value) => Validators.studentId(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        labelText: "Phone",
                        hintText: "01XXXXXXXXX",
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) => Validators.phone(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Email",
                        hintText: "Enter email",
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) => Validators.email(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Password",
                        hintText: "Enter password",
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) => Validators.password(value),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 6),
                        child: Text(
                          "Password: 8+ characters with an uppercase letter, "
                          "a lowercase letter, a digit and a symbol (e.g. @ # ! ?)",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      InputField(
                        controller: _cPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Confirm Password",
                        hintText: "Enter password again",
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  register();
                                } else {
                                  _showMessage(
                                    "Please fix the fields marked in red.",
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMaroon,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(150, 45),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Register"),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(foregroundColor: kMaroon),
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
      ),
    );
  }
}