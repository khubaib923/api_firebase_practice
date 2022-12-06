import 'dart:developer';

import 'package:api_practice/home_screen.dart';
import 'package:api_practice/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  Future<void>googleSignin()async{
    GoogleSignIn googleSignIn=GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount=await googleSignIn.signIn();
    if(googleSignInAccount != null){
      GoogleSignInAuthentication googleAuth=await googleSignInAccount.authentication;
      if(googleAuth.accessToken !=null && googleAuth.idToken != null){
        try{
          await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken)
          ).then((value){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeScreens()));
          });
        }
        on FirebaseAuthException catch(e){
          log(e.code.toString());
        }
      }

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign in"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            googleSignin();
          },
          child: const Text("Sign in with google"),
        ),
      ),
    );
  }
}
