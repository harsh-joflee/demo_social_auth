import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'firebase_options.dart';

//REFER THIS YOUTUBE VIDEO FOR MORE
// https://www.youtube.com/watch?v=yPe50kXmlPA&t=21s

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //INIT FIREBASE APP
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Social Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Social Auth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //FACEBOOK AUTHENTICATION
  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]);

    if (result.status == LoginStatus.success) {
      // Create a credential from the access token
      if (result.accessToken?.token != null) {
        Map<String, dynamic> facebookData =
            await FacebookAuth.instance.getUserData();
        log(facebookData.toString(), name: 'FACEBOOK-JSON-DATA');
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Once signed in, return the UserCredential
        UserCredential userData = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        log(userData.toString(), name: 'FIREBASE-USER-JSON-DATA');
      }
    } else {
      log('${result.status.toString()} && ${result.message.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: signInWithFacebook,
          tooltip: 'Increment',
          child: const Icon(Icons.facebook),
        ),
      ),
    );
  }
}
