import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:birthday_social_app/home.dart';
import 'package:birthday_social_app/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // TODO: Add a handshake with storage and see if the user already filled out profile.
                // If profile is filled, connect to HomePage without route.
                // Otherwise, connect to NamePage with route.
                //return HomePage();
                return BirthdayApp();
              } else {
                return LoginPage();
              }
            }
        )
    );
  }
}
