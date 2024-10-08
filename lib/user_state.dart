import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Jobs/jobs_screen.dart';
import 'package:ijob_clone_app/LoginPage/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:(ctx,userSnapshot)
      {
        if(userSnapshot.data == null)
        {
          print('user is not logged in yet');
          return Login();
        }
        else if(userSnapshot.hasData)
        {
          print('user is logged in');
          return JobScreen();
        }
        else if(userSnapshot.hasError)
        {
          return const  Scaffold(
            body: Center(child: Text('AN error has been occured Try Again Later'),),
          );
        }
        else if(userSnapshot.connectionState == ConnectionState.waiting)
        {
          return const  Scaffold(
            body: Center(
              child:CircularProgressIndicator(),),
          );
        }
        return const Scaffold(
          body: Center(child: Text('Something Went wrong'),),
        );

      });
  }
}