import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit%202.dart';
import 'package:todo_app/cubit/states%202.dart';
import 'package:todo_app/screens/archive_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/new_task_screen.dart';
import 'package:todo_app/shared/colors.dart';
import 'package:todo_app/shared/styles.dart';
import '../shared/Utility.dart';

class HomeScreen extends StatelessWidget {
  var ScaffoldKey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();

List<String> titles=[
  "New Tasks",
  "Done Tasks",
  "Archive Tasks",
];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit,ToDoAppStates>(
      listener: (context, state)  {},
      builder: (context,state){
        List<Widget> screens=[
          NewTasksScreen(
              tasks: ToDoAppCubit.get(context).newTasks,
          ),
          DoneTasksScreen(tasks: ToDoAppCubit.get(context).doneTasks,),
          ArchiveTasksScreen(tasks: ToDoAppCubit.get(context).archiveTasks,),
        ];
        return Scaffold(
        key: ScaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (ToDoAppCubit.get(context).isShown==false) {
              ScaffoldKey.currentState!.showBottomSheet((context) {
                return Container(
                  //  color: Colors.teal,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Utility.defaultFormField(
                            controller: titleController,
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Title is required";
                              }
                            },
                            type: TextInputType.text,
                            label: "Title",
                            prefix: Icons.title,
                          ),
                          const SizedBox(height: 20,),
                          Utility.defaultFormField(
                            controller: timeController,
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Time is required";
                              }
                            },
                            type: TextInputType.number,
                            readOnly: true,
                            label: "Time",
                            onTap: (){
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text=value!.format(context);
                              });
                            },
                            prefix: Icons.watch_later,
                          ),
                          const SizedBox(height: 20,),
                          Utility.defaultFormField(
                              controller: dateController,
                              validator: (value) {
                                if(value!.isEmpty) {
                                  return "Date is required";
                                }
                              },
                              type: TextInputType.number,
                              label: "Date",
                              readOnly: true,
                              prefix: Icons.date_range,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse("2025-05-25"),
                                ).then((value) {
                                  dateController.text=DateFormat.yMMMMd().format(value!);
                                });
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
              ToDoAppCubit.get(context).changeBottomSheetStatus();
            }else {
              if (formkey.currentState!.validate()) {
                ToDoAppCubit.get(context).insertToDatabase(
                    titleController.text,
                    dateController.text,
                    timeController.text,
                ).then((value) {
                  Navigator.pop(context);
                  ToDoAppCubit.get(context).changeBottomSheetStatus();
                });
              }
            }
          },
          backgroundColor:MyColors.mainColor,
          child:  Icon(
            ToDoAppCubit.get(context).isShown? Icons.add:Icons.text_rotation_angleup_sharp,
          ),
        ),
        appBar: AppBar(
          backgroundColor: MyColors.mainColor,
          title:  Text(titles[ToDoAppCubit.get(context).index],style: MyStyles.headerStyle,),
          centerTitle: true,
        ),
        body: screens[ToDoAppCubit.get(context).index],
        bottomNavigationBar: BottomNavigationBar(
          items: const[
            BottomNavigationBarItem(icon:Icon(Icons.task),label: "New"),
            BottomNavigationBarItem(icon:Icon(Icons.done),label: "Done"),
            BottomNavigationBarItem(icon:Icon(Icons.architecture_outlined),label: "Archive"),
          ],
          currentIndex: ToDoAppCubit.get(context).index,
          selectedItemColor: MyColors.selectedBottomNavigationItem,
          onTap: (value){
            ToDoAppCubit.get(context).changeScreens(value);
          },
          backgroundColor:MyColors.mainColor ,
        ),
      );},
    );
  }
}