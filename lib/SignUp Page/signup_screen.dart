import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ijob_clone_app/services/global_methods.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  final FocusNode _phoneNumberFocusNode=FocusNode();
  final FocusNode _positionCPFocusNode=FocusNode();


  File? imageFile;
  String? imageUrl;


  // final _loginFormKey=GlobalKey<FormState>();

  final TextEditingController _fullNameController =TextEditingController(text: '');
  final TextEditingController _emailTextController=TextEditingController(text: '');
  final TextEditingController _passTextController=TextEditingController(text: '');
  final TextEditingController _phoneNumberTextController=TextEditingController(text: '');
  final  TextEditingController _locationTextController=TextEditingController(text: '');

  bool _obscureText=true;
  bool _isLoading=false;

  final FirebaseAuth _auth=FirebaseAuth.instance;


  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberTextController.dispose();
    _locationTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _positionCPFocusNode.dispose();
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

  void _showImageDialog(){
    showDialog(
      context:context,
      builder: (context){
        return AlertDialog(title: Text('Please choose an option'),
        content: Column(mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              //create  getfromcamera
               _getFromCamera();
            },
            child: Row(
              children: [
              Padding(padding: EdgeInsets.all(4.0),
              child: Icon(Icons.camera,color: Colors.purple,),
              ),
              Text('Camera',style: TextStyle(color: Colors.purple),)
            ],),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              //create  getfromgalery
              _getFromGallery();
            },
            child: Row(
              children: [
              Padding(padding: EdgeInsets.all(4.0),
              child: Icon(Icons.image,color: Colors.purple,),
              ),
              Text('Gallery ',style: TextStyle(color: Colors.purple),)
            ],),
          ),
          
        ],
        ),
        );
      });
  }

  void _getFromCamera() async
  {
    XFile? pickFile=await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async
  {
    XFile? pickFile=await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickFile!.path);
    Navigator.pop(context);
  }
  void _cropImage(filePath) async
  {
    CroppedFile? croppedImage= await  ImageCropper().cropImage(
      sourcePath: filePath,maxHeight: 1080,maxWidth: 1080);
      if(croppedImage != null)
      {
        setState(() {
          imageFile=File(croppedImage.path);
        });
      }

  }
  // void _submitFormOnSignUp() async
  // {
  //   final isValid=_signUpFormKey.currentState!.validate();
  //   if(isValid)
  //   {
  //     setState(() {
  //       _isLoading=true;
  //     });
  //     try
  //     {
  //       await _auth.signInWithEmailAndPassword(email: _emailTextController.text.trim(), password:_passTextController.text.trim());
  //       Navigator.canPop(context) ? Navigator.pop(context) : null;
  //     }
  //     catch(error)
  //     {
  //       setState(() {
  //         _isLoading=false;
  //       });
  //       GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
  //       print('error occured $error');
  //     }
  //   }
  //   setState(() {
  //     _isLoading=false;
  //   });
  // }

  void _submitFormOnSignUp() async
  {
    final isValid =_signUpFormKey.currentState!.validate();
    if(isValid)
    {
      if(imageFile == null)
      {
        GlobalMethod.showErrorDialog(error: 'Please pick an image', ctx: context);
        return;
      }
      setState(() {
        _isLoading=true;
      });
      try
      {
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim().toLowerCase()
        );
        final User? user = _auth.currentUser;
        final _uid=user!.uid;
        final ref=FirebaseStorage.instance.ref().child('userImages').child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id':_uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text,
          'userImage': imageUrl,
          'phoneNumber': _phoneNumberTextController.text,
          'location': _locationTextController.text,
          'createdAt':Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) :null; 
      }catch (error)
      {
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
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
                            onTap: (){
                              _showImageDialog();
                            },
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
                    const SizedBox(height: 20,),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passTextController,
                      obscureText: !_obscureText,
                      validator: (value){
                        if(value!.isEmpty || value.length<7){
                          return 'Please enter a valid password';
                        }
                        else{
                          return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration:  InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              _obscureText=!_obscureText;
                            });
                          },
                          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,color: Colors.white,),
                        ),
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
                    SizedBox(height: 20,),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_positionCPFocusNode),
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberTextController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is missing.';
                        }
                        else{
                          return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
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
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_positionCPFocusNode),
                      keyboardType: TextInputType.text,
                      controller:_locationTextController ,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is missing.';
                        }
                        else{
                          return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Company Address ',
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
                    SizedBox(height: 25,),
                    _isLoading
                    ?
                    Center(child: Container(width: 70,height: 70,
                    child: CircularProgressIndicator(),
                    ),
                    )
                    :
                    MaterialButton(
                      onPressed: (){
                        // create submit form on sign up 
                        _submitFormOnSignUp();
                      },
                      color: Colors.cyan,
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                          ],
                        ),
                      ),
                      ),
                      SizedBox(height: 40,),
                      Center(child: RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already Have an account ? ',
                          style: TextStyle(
                            color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)

                          
                        ),
                        TextSpan(text: ' '),
                        TextSpan(recognizer: TapGestureRecognizer()
                        ..onTap=()=> Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                        text: 'Login',
                        style: TextStyle(color: Colors.cyan,fontWeight: FontWeight.bold,fontSize: 16)
                        )
                      ]
                      )),)

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