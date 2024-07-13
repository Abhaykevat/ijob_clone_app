// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:ijob_clone_app/services/global_variables.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FocusNode _passFocusNode=FocusNode();


  final _loginFormKey=GlobalKey<FormState>();

  final TextEditingController _emailTextController=TextEditingController(text: '');
  final TextEditingController _passTextController=TextEditingController(text: '');

  bool _obscureText=true;

  
  @override
  void dispose() {
    _animationController.dispose();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CachedNetworkImage(
          //   imageUrl: 'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
          //   // imageUrl: "http://mvs.bslmeiyu.com/storage/profile/2022-05-02-626fc39bf18a6.png",
          //   placeholder: (context,url)=>Image.asset('assets/images/wallpaper.jpg',
          //   fit: BoxFit.fill,
          //   ),
          //   errorWidget: (context,url,error)=>const Icon(Icons.error),
          //   width: double.infinity,
          //   height: double.infinity,
          //   fit: BoxFit.cover,
          //   alignment: FractionalOffset(_animation.value, 0),
          //   ),
          Image.asset('assets/images/animation.jpg',
          fit: BoxFit.cover,alignment: FractionalOffset(_animation.value, 0),width: double.infinity,height: double.infinity,),
          Container(
            color: Colors.black54,
            child: Padding(padding:const  EdgeInsets.symmetric(horizontal: 16,vertical: 80),
            child: ListView(
              children: [
                Padding(padding:const EdgeInsets.only(left: 80,right: 80),
                child: Image.asset('assets/images/login.png'),
                ),
                SizedBox(height: 15,),
                Form(key:_loginFormKey,child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: ()=>FocusScope.of(context).requestFocus(_passFocusNode),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
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
                    const SizedBox(height: 5,),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: _passFocusNode,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passTextController,
                      obscureText: !_obscureText,
                      validator: (value){
                        if(value!.isEmpty || value.length <7){
                          return 'Please enter a valid password';
                        }else{
                           return null;
                        }
                      },
                      style:const  TextStyle(color: Colors.white),
                      decoration: InputDecoration(
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
                    )

                  ],
                ),)
              ],
            ),
            ),
          )
        ],
      ),
    );
  }
}