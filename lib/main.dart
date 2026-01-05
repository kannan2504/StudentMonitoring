import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/features/login_screen/Data/Logic/AuthRemoteDataSource.dart';
import 'package:loginpage/features/login_screen/Data/Repository/RepoImpl.dart';
import 'package:loginpage/features/login_screen/Domain/Usecases/GoogleSIgninUsecase.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/home_screen.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/registerPage.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/splash_screen.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/student_lists.dart';
import 'package:loginpage/features/login_screen/Presentation/provider/loginProvider.dart';
import 'package:loginpage/features/login_screen/Presentation/pages/loginPage.dart';
import 'package:loginpage/features/login_screen/Presentation/provider/themeprovider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("🔥🔥 FIREBASE CONNECTED SUCCESSFULLY 🔥🔥");
  } catch (e) {
    print("❌ FIREBASE CONNECTION FAILED: $e");
  }
  final remote = AuthRemoteDataSourceimpl();
  final repository = AuthRepositoryImpl(remote);
  final useCase = GoogleSignInUseCase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(useCase)),
        ChangeNotifierProvider(create: (_) => Themeprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => HomePage(),
        AppRoutes.reset: (context) => ResetScreen(),
        AppRoutes.editpage: (context) => EditPage(),
        AppRoutes.studentlists: (context) => StudentLists(),
      },
    );
  }
}

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String reset = '/reset';
  static const String editpage = '/editpage';
  static const String studentform = '/studentform';
  static const String studentlists = '/studentList';
}
