import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/auth/register_page.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';
import 'package:final_project_debojyoti_64_g_306/utils/validators.dart';
import 'package:final_project_debojyoti_64_g_306/widget/input_field.dart';

class LoginPage extends StatefulWidget { 
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() { //after a successful login/refresh disposes the datas that was in the text box
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


// THE SINGLE QUOTED STRINGS ARE THE BUILT IN ERROR MESSAGE OF FIREBASE
  String _friendlyMessage(FirebaseAuthException e) {
    final code = e.code;
    if (code == 'invalid-credential' || 
        code == 'user-not-found' ||
        code == 'wrong-password') {
      return "Wrong email or password.";
    }
    if (code == 'too-many-requests') return "Too many attempts. Try later.";
    if (code == 'network-request-failed') return "No internet connection.";
    if (code == 'operation-not-allowed') {
      return "Email/Password sign-in is not enabled in the Firebase console.";
    }
    return "Login failed [$code]: ${e.message}";
  }
  

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // authGate sees the new user and swaps this page for HomePage.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_friendlyMessage(e))));
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FATFLIX"),
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
                        "FATFLIX",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: kMaroon,
                        ),
                      ),
                      const Text("Login Form", style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 25),
                      InputField(                             //EMAIL INPUT
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Email",
                        hintText: "Enter email",
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) => Validators.email(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(//                            PASSWORD INPUT
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Password",
                        hintText: "Enter password",
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  login();
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
                            : const Text("Login"),
                      ),
                      const SizedBox(height: 10),
                      // textButton shows the hand cursor+ hover highlight automatically.
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        ),
                        style: TextButton.styleFrom(foregroundColor: kMaroon),
                        child: const Text(
                          "Don't have an ID? Register now",
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