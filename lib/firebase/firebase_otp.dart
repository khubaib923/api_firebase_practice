import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseOtpScreen extends StatefulWidget {
  const FirebaseOtpScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseOtpScreen> createState() => _FirebaseOtpScreenState();
}

class _FirebaseOtpScreenState extends State<FirebaseOtpScreen> {
  TextEditingController phoneController=TextEditingController();

  void createWithMobileNo(phoneNo){
    final phoneNumber= "+92" + phoneNo;
    if(phoneNo==""){
      log("please enter the details");
    }
    else{
      sendOtp(phoneNumber);
    }
  }
  Future<void>sendOtp(phoneNo)async{
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential){},
        verificationFailed: (ex){
          log(ex.code.toString());
        },
        codeSent: (verificationId,resendToken){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtpScreen(verificationId: verificationId)));


        },
        codeAutoRetrievalTimeout: (verificationId){},
        timeout: const Duration(seconds: 30)
    );
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
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "phone number"
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed:(){
              createWithMobileNo(phoneController.text.trim());
            }, child: const Text("Send Otp")
            )
          ],
        ),
      ),
    );
  }
}

class VerifyOtpScreen extends StatefulWidget {
  final verificationId;
  const VerifyOtpScreen({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController=TextEditingController();
  Future<void>verifyOtp(otp)async{
    try{
      PhoneAuthCredential phoneAuthCredential= PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode:otp );
      UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if(userCredential.user!=null){
        log("user created");
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
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: "Otp"
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              verifyOtp(otpController.text.trim());
            }, child: const Text("login")
            )
          ],
        ),
      ),

    );
  }
}

