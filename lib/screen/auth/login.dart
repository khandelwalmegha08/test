import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mandiweb/controller/auth_controller/auth_controller.dart';
import 'package:mandiweb/widgets/buttons/custom_fbuttons.dart';
import 'package:mandiweb/widgets/custom_toaster.dart';


import '../../constant/constant_color.dart';
import '../../widgets/custom_textfield/custom_text.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //LoginController loginController = Get.put(LoginController());


  int secondsRemaining = 30;

  bool enableResend = false;

  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  TextEditingController userName = new TextEditingController();
  TextEditingController mobile = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: (){Get.back();},
                        child: CircleAvatar(backgroundColor: Colors.white
                            ,child: Icon(Icons.arrow_back_ios,color: Colors.black, size: 20,))
                    )
                  ],

                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.top),

              welcome(),
              text(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                child: Row(
                  children: [
                    const Text("Full Name ",style: TextStyle()),
                    Text("*",style: TextStyle().copyWith(color: Colors.red)),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                  child: CustomTextField(
                    onTap:() {
                    },
                    textInputType: TextInputType.name,
                    controller: userName,
                    enable: true,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                child: Row(
                  children: [
                    const Text("Mobile No. ",style: TextStyle()),
                    Text("*",style: TextStyle().copyWith(color: Colors.red)),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                  child: CustomPhoneTextField(
                    onTap:() {
                    },
                    textInputType: TextInputType.phone,
                    controller: mobile,
                    phoneNumber: true,
                    enable: true,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomFButton(onTap: (){

                  if(userName.text.isEmpty){

                    customToast(type: "error", message: "Please Enter User Name");
                  }
                  else if(mobile.text.isEmpty){
                    customToast(type: "error", message: "Please Enter Mobile No.");
                  }
                  else{

                    if(AuthController().apiUrl.localStorage
                        .read("sellerId")==null){
                      customToast(type: "error", message: "Thanks for completing the demo");
                    }
                    else{
                      EasyLoading.show(
                        status: 'Loading...',
                      );

                      AuthController().login(mobile: mobile.text,username: userName.text);
                    }

                  }
                  //Get.to(OtpScreen());

                  },title: "Proceed",),


              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget welcome() => Container(
    margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
    child: const Text(
      "Hello!",
      style: TextStyle(
          color: Color(0xff2B2B2B),
          fontSize: 32.0, fontWeight: FontWeight.w700),
    ),
  );

  Widget text() => Container(
    margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 30.0),
    child: Text(
      "Fill your details to Proceed.",
      style: TextStyle(
          color: Color(0xff707B81
          ),
          fontSize: 16.0,
          fontWeight: FontWeight.w400),
    ),
  );

  Widget otpTextField(BuildContext context, bool autoFocus) {
    return Container(

      height: MediaQuery.of(context).size.shortestSide * 0.13,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: TextFormField(
          autofocus: autoFocus,
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black))),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLines: 1,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }

  Widget button({required Function onPress, required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      height: 50,
      width: Get.width,
      child: MaterialButton(
        onPressed: () {
          onPress();
        },
        color: kblue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

  @override
  dispose(){
    timer.cancel();
    super.dispose();
  }

}
