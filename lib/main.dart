import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/remote_config_provider.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:flutter_firebase/screens/login_screen.dart';
import 'package:flutter_firebase/screens/signup_screen.dart';
import 'package:flutter_firebase/screens/splash_screen.dart'; 
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:provider/provider.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RemoteConfigProvider()),
      ],
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'e-Shop',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginScreen(),
        ),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
      },
    ),
    );
  }
}
