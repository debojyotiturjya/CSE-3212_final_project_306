import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/auth/auth_gate.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';
import 'package:final_project_debojyoti_64_g_306/firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FATFLIX",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: const ColorScheme.dark(
          primary: kPrimary,
          secondary: kSecondary,
          surface: kCard,
          onSurface: kText,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kAppBar,
          foregroundColor: kText,
        ),
      ),
      home: const AuthGate(),
    );
  }
}