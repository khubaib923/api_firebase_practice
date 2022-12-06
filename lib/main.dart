
import 'dart:convert';
import 'package:api_practice/ProductModel.dart';
import 'package:api_practice/create_account.dart';
import 'package:api_practice/crud_operation.dart';
import 'package:api_practice/firebase/firebase_email.dart';
import 'package:api_practice/firebase/firebase_otp.dart';
import 'package:api_practice/firebase/google_signin.dart';
import 'package:api_practice/firebase/signin_email.dart';
import 'package:api_practice/image_uploaded.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

String uuid = const Uuid().v1();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:CrudOperation()
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<ProductModel>getProductData()async{
    final response=await http.get(Uri.parse("https://dummyjson.com/carts"));
    if(response.statusCode == 200){
      final decodedData = jsonDecode(response.body.toString());

      return ProductModel.fromJson(decodedData);
    }
    else{
      return ProductModel();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder<ProductModel>(
        future: getProductData(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.connectionState==ConnectionState.active || snapshot.connectionState==ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }
            else if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.requireData.carts!.length,
                  itemBuilder: (context,index){
                    return ListView.builder(
                        itemCount: snapshot.requireData.carts![index].products!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,indexx){
                          return ListTile(
                            title: Text(snapshot.requireData.carts![index].products![indexx].title.toString()),
                            subtitle: Text(snapshot.requireData.carts![index].products![indexx].price.toString()),
                            trailing: Text(snapshot.requireData.carts![index].products![indexx].id.toString()),
                          );
                        }
                    );
                  }
              );
            }
            else{
              return const Center(child: Text("something went wrong"));
            }
          }
          else{
            return const Center(child: Text("something went wrong"));
          }
        },

      )
    );
  }
}



