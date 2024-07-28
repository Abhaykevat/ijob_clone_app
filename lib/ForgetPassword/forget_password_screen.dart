import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijob_clone_app/LoginPage/login_screen.dart';
import 'package:ijob_clone_app/services/global_variables.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with TickerProviderStateMixin
{
  late Animation<double> _animation;
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _forgetPasswordTextController=TextEditingController(text: '');
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

  void _forgetPassSubmitForm() async
  {
    try
    {
      await _auth.sendPasswordResetEmail(
        email: _forgetPasswordTextController.text,
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
    }catch(error)
    {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            // imageUrl: 'https://images.unsplash.com/photo-1494145904049-0dca59b4bbad?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            imageUrl: forgetUrlImage,
            placeholder: (context,url)=>Image.asset('assets/images/wallpaper.jpg',
            fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error)=>const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  SizedBox(height: size.height*0.1,),
                  const Text('Forget Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Signatra',
                    fontWeight: FontWeight.bold,fontSize: 55),),
                  const SizedBox(height: 10,),
                  const Text('Email Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,fontSize: 18),),
                    SizedBox(height: 20,),
                  TextField(
                    controller:_forgetPasswordTextController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white54,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      )
                    ),
                    // style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20,),
                  MaterialButton(
                    onPressed: (){
                      _forgetPassSubmitForm();
                    },
                    color: Colors.cyan,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:const Padding(padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text("Reset Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,),),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
} 