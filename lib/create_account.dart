import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();
  Future<void> createAccount(String email,String password) async{
    final response=await http.post(Uri.parse("https://reqres.in/api/login"),body: {
      "email":email,
      "password":password
    });
    if(response.statusCode==200){
      log("account created");
      final decodedData=jsonDecode(response.body);
      log(decodedData.toString());
    }
    else{
      log("something went wrong");
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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email"
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "please enter the value";
                  }
                  else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: "Password"
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "please enter the value";
                  }
                  else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                if(formKey.currentState!.validate()==true){
                  createAccount(emailController.text.trim(), passwordController.text.trim());
                }


              }, child: const Text("Create Account"))
            ],
          ),
        ),
      ),
    );
  }
}
