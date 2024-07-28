import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ijob_clone_app/Persistent/persistent.dart';
import 'package:ijob_clone_app/Widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final TextEditingController _jobCategoryController = TextEditingController(text: "Select Job Category");
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Widget _textTitles({required String label})
  {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,fontWeight: FontWeight.bold),),
    );
  }
  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
    })
    {
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: InkWell(
          onTap: (){
            fct();
          },
          child: TextFormField(
            validator: (value){
              if(value!.isEmpty){
                return 'Value is missing';
              }
              return null;
            },
            controller: controller,
            enabled: enabled,
            key: ValueKey(valueKey),
            style: TextStyle(
              color: Colors.white
            ),
            maxLines: valueKey == 'JobDescription' ? 3 : 1,
            maxLength: maxLength,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),

              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),

              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            ),
          ),
        ),
      );
    }
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
                        _jobCategoryController.text=Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
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
               child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 16),))
            ],
        );
      });
    }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum:2),
        backgroundColor: Colors.transparent,
      //   appBar: AppBar(
      //     title: Text('Upload Job Now'),
      //     centerTitle: true,
      //     // backgroundColor: Colors.blue,
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [Colors.deepOrange.shade300,Colors.blueAccent],
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     stops: const [0.2,0.9]
      //     )
      // ),
      //     ),
      //     ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(7.0),
              child: Card(
                color: Colors.white10,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Please fill all fields',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontFamily: 'Signatra',
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ), 
                      SizedBox(height: 10,),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textTitles(label: 'Job Category: '),
                               _textFormFields(
                                valueKey: 'JobCategory', 
                                controller: _jobCategoryController,
                                enabled: false,
                                fct: (){
                                  _showTaskCategoriesDialog(size: size);
                                }, 
                                maxLength: 100),
                              _textTitles(label: 'Job Title :'),
                              _textFormFields(
                                valueKey: 'JobTitle', 
                                controller: _jobTitleController,
                                enabled: true,
                                fct: (){}, 
                                maxLength: 100),
                              _textTitles(label: 'Job Description :'),
                              _textFormFields(
                                valueKey: 'JobDescription', 
                                controller: _jobDescriptionController,
                                enabled: true,
                                fct: (){}, 
                                maxLength: 100),
                              _textTitles(label: 'Job Deadline Date :'),
                              _textFormFields(
                                valueKey: 'Deadline', 
                                controller: _deadlineDateController,
                                enabled: true,
                                fct: (){}, 
                                maxLength: 100),
                              

                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: _isLoading
                          ? CircularProgressIndicator()
                          : MaterialButton(onPressed: (){},
                          color: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Post Now',style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  fontFamily: 'Signatra',
                                ),),
                                SizedBox(width: 10),
                                Icon(Icons.upload_file,color: Colors.white,)
                              ],
                            ),
                          ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),),
          ),
      ),
    );
  }
}