import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ijob_clone_app/services/global_methods.dart';

class SignUp extends StatefulWidget {

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin
{

  late Animation<double> _animation;
  late AnimationController _animationController;
  
  final _signUpFormKey=GlobalKey<FormState>();

  final FocusNode _emailFocusNode=FocusNode();
  final FocusNode _passFocusNode=FocusNode();

  File? imageFile;


  final _loginFormKey=GlobalKey<FormState>();

  final TextEditingController _fullNameController =TextEditingController(text: '');
  final TextEditingController _emailTextController=TextEditingController(text: '');
  final TextEditingController _passTextController=TextEditingController(text: '');

  bool _obscureText=true;
  bool _isLoading=false;

  final FirebaseAuth _auth=FirebaseAuth.instance;


  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    // _passFocusNode.dispose(); 
    super.dispose();
  }

  @override
  void initState() {
    _animationController=AnimationController(vsync: this,duration: const Duration(seconds: 20));
    _animation=CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener((){
        setState(() {

        });
      })
      ..addStatusListener((animationStatus){
        if(animationStatus==AnimationStatus.completed){
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }
  void _submitFormOnLogin() async
  {
    final isValid=_loginFormKey.currentState!.validate();
    if(isValid)
    {
      setState(() {
        _isLoading=true;
      });
      try
      {
        await _auth.signInWithEmailAndPassword(email: _emailTextController.text.trim(), password:_passTextController.text.trim());
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      }
      catch(error)
      {
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('error occured $error');
      }
    }
    setState(() {
      _isLoading=false;
    });
  }



  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'https://plus.unsplash.com/premium_photo-1678903964473-1271ecfb0288?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            // imageUrl: "http://mvs.bslmeiyu.com/storage/profile/2022-05-02-626fc39bf18a6.png",
            placeholder: (context,url)=>Image.asset('assets/images/wallpaper.jpg',
            fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error)=>const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
            ),
            Container(
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
                child: ListView(
                  children: [
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.width*0.24,
                                width: size.width*0.24,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Colors.cyanAccent),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ClipRRect(borderRadius: BorderRadius.circular(16),
                                child: imageFile == null 
                                 ? Icon(Icons.camera_enhance_sharp,color: Colors.cyan,size: 30,)
                                 : Image.file(imageFile!,fit: BoxFit.fill,),
                                ),

                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_emailFocusNode),
                      keyboardType: TextInputType.name,
                      controller: _fullNameController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is missing';
                        }
                        else{
                          return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'fullname / Company name',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red
                        ))
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_passFocusNode),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController ,
                      validator: (value){
                        if(value!.isEmpty || !value.contains('@')){
                          return 'Please enter a valid email address';
                        }
                        else{
                          return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red
                        ))
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_passFocusNode),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController ,
                      validator: (value){
                        if(value!.isEmpty || !value.contains('@')){
                          return 'Please enter a valid email address';
                        }
                        else{
                          return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red
                        ))
                      ),
                    ),
                    
                    
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}