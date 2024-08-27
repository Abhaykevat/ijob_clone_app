import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Persistent/persistent.dart';
import 'package:ijob_clone_app/Search/search_job.dart';
import 'package:ijob_clone_app/Widgets/bottom_nav_bar.dart';
import 'package:ijob_clone_app/user_state.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  String? jobCategoryFilter;

  _showTaskCategoriesDialog({required Size size})
    {
      showDialog(context: context,
      builder:(ctx){
        return AlertDialog(
          backgroundColor: Colors.black45,
          title: Text(
            'Job Category',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,color: Colors.white),),
            content: Container(
              width: size.width*0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:Persistent.jobCategoryList.length ,
                itemBuilder: (ctx,index){
                  return InkWell(
                    onTap: (){
                      setState(() {
                        jobCategoryFilter=Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                        'jobCategoryList[index], ${Persistent.jobCategoryList[index]}'
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_right_alt_outlined,color: Colors.grey,),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(Persistent.jobCategoryList[index]
                          ,style: TextStyle(fontSize: 16,color: Colors.grey),),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
               child: Text('Close',style: TextStyle(color: Colors.white,fontSize: 16),)),
              TextButton(onPressed: (){
                setState(() {
                  jobCategoryFilter=null;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }, child: Text('Cancel Filter',style: TextStyle(color: Colors.white),))
            ],
        );
      });
    }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
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
          // title: Text('Job Screen'),
          // centerTitle: true,
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
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            _showTaskCategoriesDialog(size:size);
          },
           icon:const Icon(Icons.filter_list_rounded,color: Colors.black,)),
           actions: [
            IconButton(
              onPressed: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>SearchScreen()));
              },
              icon: Icon(Icons.search,color: Colors.black,))
           ],
          ),

      ),
    );
  }
}
