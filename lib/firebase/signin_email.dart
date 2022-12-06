import 'dart:developer';

import 'package:api_practice/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInEmailScreen extends StatefulWidget {
  const SignInEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignInEmailScreen> createState() => _SignInEmailScreenState();
}

class _SignInEmailScreenState extends State<SignInEmailScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  void checkTextField(email,password){
    if(email=="" || password==""){
      log("please enter the details");
    }
    else{
      signIn(email, password);
    }
  }
  Future<void>signIn(email,password)async{
    try{
      UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!=null){
        if(mounted){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreens()));
        }
      }
      else{
        log("user not found");
      }

    }
    on FirebaseAuthException catch(e){
      log(e.code.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email"
              ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: "Password"
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              checkTextField(emailController.text.trim(), passwordController.text.trim());
            }, child:const Text("Signin"))


          ],
        ),
      ),
    );
  }
}
