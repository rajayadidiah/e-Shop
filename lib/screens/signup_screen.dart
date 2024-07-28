import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth/firebase_auth_service.dart';
import 'package:flutter_firebase/global/toast.dart';
import 'package:flutter_firebase/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey1,
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
                                controller: _nameController,
                                key: ValueKey('name'),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                style: Theme.of(context).textTheme.labelMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  hintText: 'Name',
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter valid name';
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
                            SizedBox(
                              height: 10,
                            ),
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
                          _signUp();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xff0C54BE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: isSigningUp
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Sign Up",
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
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
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
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                  (route) => false);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xff0C54BE),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "Poppins",
                              ),
                            ),
                          )
                        ],
                      )
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

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(username, email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happened");
    }
  }
}
