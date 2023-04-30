import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../main.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await _auth.signInWithCredential(credential);
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            headerBuilder: (context, constraints, _) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 4,
                      child: Image.asset('assets/images/Marijane.png'),
                    ),
                    Text(
                      'Marijane',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              );
            },
            footerBuilder: (context, constraints) {
              return Column(children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final UserCredential userCredential =
                          await signInWithGoogle();
                      // Handle successful sign-in
                    } catch (e) {
                      // Handle sign-in errors
                    }
                  },
                  child: const Text('Sign in with Google'),
                ),
              ]);
            },
            providerConfigs: const [
              EmailProviderConfiguration(),
            ],
            /* ElevatedButton(
              onPressed: () async {
                try {
                  final UserCredential userCredential =
                      await signInWithGoogle();
                  // Handle successful sign-in
                } catch (e) {
                  // Handle sign-in errors
                }
              },
              child: const Text('Sign in with Google'),
            ), */
          );
        }

        return const MyHomePage(
          title: 'Marijane',
        );
      },
    );
  }
}
