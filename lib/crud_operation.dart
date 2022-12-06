import 'dart:developer';
import 'dart:io';

import 'package:api_practice/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CrudOperation extends StatefulWidget {
  const CrudOperation({Key? key}) : super(key: key);

  @override
  State<CrudOperation> createState() => _CrudOperationState();
}

class _CrudOperationState extends State<CrudOperation> {
  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  File? pickedImage;
  Future<void>pickImage()async{
    final pickedFile=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      setState(() {
        pickedImage=File(pickedFile.path);
      });
    }
  }
  Future<void>uploadData()async{
    UploadTask uploadTask=FirebaseStorage.instance.ref().child("picture").child(uuid).putFile(pickedImage!);
    TaskSnapshot taskSnapshot=await uploadTask;
    String url=await taskSnapshot.ref.getDownloadURL();
    Map<String,dynamic>data={
      "name":nameController.text.trim(),
      "age":ageController.text.trim(),
      "imageUrl":url
    };
    await FirebaseFirestore.instance.collection("users").add(data).then((value){
      nameController.clear();
      ageController.clear();
      log("value is added");
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crud Operation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  pickImage();
                },
                child: CircleAvatar(
                  backgroundImage: pickedImage!=null?FileImage(pickedImage!):null,
                  backgroundColor: pickedImage==null?Colors.blue:null,
                  radius: 40,
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "name"
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                    labelText: "age"
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                uploadData();
              }, child: const Text("Insert")),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, child: const Text("Read")),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, child: const Text("Update")),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, child: const Text("Delete")),
              const SizedBox(height: 10,),
              SizedBox(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection("users").snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.hasData && snapshot.data!=null){
                        return ListView.builder(
                            itemCount: snapshot.requireData.docs.length,
                            itemBuilder: (context,index){
                              final data=snapshot.requireData.docs[index].data() as Map<String,dynamic>;
                              return ListTile(
                                title: Text(data["name"].toString()),
                                subtitle: Text(data["age"].toString()),
                                trailing: GestureDetector(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection("users").doc(snapshot.requireData.docs[index].id).delete();
                                    },
                                    child: const Icon(Icons.delete)),
                                leading: GestureDetector(
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection("users").doc(snapshot.requireData.docs[index].id).update({
                                        "name":"altaf",
                                        "age":"34",
                                        "imageUrl":"www.youtube.com"
                                      });
                                    },
                                    child: const Icon(Icons.update)),
                              );
                            }
                        );
                      }
                      else{
                        return const Text("No data");
                      }

                    }
                    return const CircularProgressIndicator();

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
