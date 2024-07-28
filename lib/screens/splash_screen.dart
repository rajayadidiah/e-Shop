import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    Future.delayed(
      Duration(seconds: 1),(){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
    }
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF5F9FD),
        child: 
      Center(
        child: Text(
          "e-Shop",
          style: TextStyle(
            color: Color(0xff0C54BE),
            fontWeight: FontWeight.bold,
            fontSize: 50,
            fontFamily: "Poppins",
          ),
        ),
      ),
    )
    );
  }
}
