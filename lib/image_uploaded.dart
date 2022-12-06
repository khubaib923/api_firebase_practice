import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploadedScreen extends StatefulWidget {
  const ImageUploadedScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadedScreen> createState() => _ImageUploadedScreenState();
}

class _ImageUploadedScreenState extends State<ImageUploadedScreen> {
  File? pickedImage;
  bool isLoading=false;

  Future<void>imagePicked()async{
    XFile? image=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        pickedImage=File(image.path);
      });
    }
    else{
      log("image not selected");
    }
  }
  Future<void>uploadedImage()async{
    setState(() {
      isLoading=true;
    });
   final stream=http.ByteStream(pickedImage!.openRead());
   stream.cast();
   final length=await pickedImage!.length();
   final uri=Uri.parse("https://fakestoreapi.com/products");
   final request=http.MultipartRequest("POST",uri);
   request.fields["email"]="khubaibirfan199@gmail.com";
   final multiPartFile=http.MultipartFile(
     "image",
     stream,
     length
   );
   request.files.add(multiPartFile);
   final response=await request.send();
   if(response.statusCode==200){
     log("image uploaded");
     setState(() {
       isLoading=false;
     });
   }
   else{
     log("something went wrong");
     setState(() {
       isLoading=false;
     });
   }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploading Image"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: (){
                  imagePicked();
                },
                child:pickedImage==null?const Text("Picked Image",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),):CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: FileImage(pickedImage!),
                  radius: 30,
                )),
            const SizedBox(height: 50,),
            ElevatedButton(onPressed: pickedImage!=null?(){
              uploadedImage();
            }:null, child:isLoading?const CircularProgressIndicator():const Text("Upload Image"))
          ],
        ),
      ),
    );
  }
}
