import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseEmailScreen extends StatefulWidget {
  const FirebaseEmailScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseEmailScreen> createState() => _FirebaseEmailScreenState();
}

class _FirebaseEmailScreenState extends State<FirebaseEmailScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();

  void checkAccount(email,password,cPassword){
    if(email=="" || password=="" || cPassword==""){
      log("please fill all the details");
    }
    else if(password != cPassword){
      log("please enter same password");
    }
    else{
      createAccount(email, password);
    }
  }

  Future<void>createAccount(email,password)async{
    try{
      UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!=null){
       log("user is created");
      }
    }
    on FirebaseAuthException catch(e){
      log(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
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
            const SizedBox(height: 20,),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: "Password"
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                  labelText: "Confirm Password"
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              checkAccount(emailController.text.trim(),passwordController.text.trim(),confirmPasswordController.text.trim());
            }, child: const Text("Create Account"))

          ],
        ),
      ),
    );
  }
}
