import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({Key? key}) : super(key: key);

  void logout(BuildContext context)async{
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn=GoogleSignIn();
    await googleSignIn.signOut().then((value){
      Navigator.pop(context);
    });
  }

  void logoutEmail()async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                logout(context);
              },
              child: const Text("Logout"),
            ),
            ElevatedButton(
              onPressed: (){
                logoutEmail();
              },
              child: const Text("Logout Email"),
            ),
          ],
        ),
      ),
    );
  }
}
