import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth/firebase_auth_service.dart';
import 'package:flutter_firebase/global/toast.dart';
import 'package:flutter_firebase/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FD),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F9FD),
        automaticallyImplyLeading: false,
        title: Text(
          "e-Shop",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff0C54BE),
            fontFamily: "Poppins",
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF5F9FD),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        onChanged: () => setState(() {}),
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                key: ValueKey('email'),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                style: Theme.of(context).textTheme.labelMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                key: ValueKey('password'),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                style: Theme.of(context).textTheme.labelMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _signIn();
                        },
                        child: Container(
                          width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xff0C54BE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isSigning
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New Here?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpScreen()),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                color: Color(0xff0C54BE),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                         ],
                        ),
                        ],
                    ),
                 ),
                 ],
             ),
            ),
        ),
     ),
   );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "some error occurred");
    }
  }
}
