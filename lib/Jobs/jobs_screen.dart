import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Widgets/bottom_nav_bar.dart';
import 'package:ijob_clone_app/user_state.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300,Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2,0.9]
          )
      ),
      child: Scaffold(
        bottomNavigationBar:BottomNavigationBarForApp(indexNum:0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Job Screen'),
          centerTitle: true,
          // backgroundColor: Colors.blue,
          flexibleSpace: Container(
            decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300,Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2,0.9]
          )
      ),
          ),
          ),
      ),
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:ijob_clone_app/user_state.dart';

// class JobScreen extends StatefulWidget {
//   const JobScreen({super.key});

//   @override
//   State<JobScreen> createState() => _JobScreenState();
// }

// class _JobScreenState extends State<JobScreen> {
//   final FirebaseAuth _auth =FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Jobs Screen"),),
//       body: ElevatedButton(onPressed: (){
//         _auth.signOut();
//         Navigator.canPop(context) ? Navigator.pop(context) : null;
//         Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=> UserState()) );
//       }, child: Text("LogOut")),
//     );
//   }
// }