import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_sql/colors.dart';
import 'package:todo_sql/screen/home_screen.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SplashScreen();
  
}

class _SplashScreen extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds : 2) , (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));

    });

  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: appBackground,
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
                width: 250,
                child: Image.asset("assets/images/todosp.png")),
            SizedBox(height: 20,) ,
            
            Text("Save Time" , style: TextStyle(fontSize: 35 ,
              fontWeight: FontWeight.bold , color: appRed ),)
          ],
        )),
  );
  }
  
}