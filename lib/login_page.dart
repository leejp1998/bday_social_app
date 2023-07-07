import 'package:flutter/material.dart';
import 'components/login_form.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
              children: [
                const SizedBox(height: 5),
                //logo
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Image(
                //       image: new AssetImage("lib/images/ssem_logo.png"),
                //       height: 80,
                //       fit: BoxFit.fitHeight,
                //       color: null,
                //       alignment: Alignment.topLeft,
                //     ),
                //   ],
                // ),
                const Expanded(child: LoginForm()),
              ]
          )
      ),
    );
  }
}