import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states%202.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates>{
  ToDoAppCubit() : super(ToDoAppInitialstate());
  static ToDoAppCubit get(BuildContext context)=> BlocProvider.of(context);

  bool isShown=false;
  int index=0;
  int num=0;

  void changeBottomSheetStatus(){
   isShown=!isShown;
   emit(ChangeBottomSheetStatusState());
 }

 void changeScreens (value){
   index = value;
   emit(ChangeScreensStatusState());
 }

  void addToNum(){
    num++;
    emit(AddToNumState());
  }

  void numDecrement(){
    num--;
    emit(DecreaseNumState());
  }

                                      ///   Database
  ///   create database
  ///   create tables
  ///   open database
  ///   insert
  ///   select
  ///   update
  ///   delete
  Database? database;
  List<Map<String, dynamic>> newTasks =[];
  List<Map<String, dynamic>> doneTasks =[];
  List<Map<String, dynamic>> archiveTasks =[];

  void createDatabase(){
    openDatabase(
        "todo.db",version: 1,
        onCreate: (Database database, int version){
          database.execute(
              "CREATE TABLE tasks ( id INTEGER PRIMARY KEY,title TEXT, data TEXT, time TEXT, status TEXT)"
          ).then((value) {
            print("database created");
          }).catchError((error){
              print(error.toString());
            });
          },
          onOpen: (Database database){
          selectFromDatabase(database);
          print("database opened");
          },
        ).then((value) {
          database =value;
          emit(CreateDatabaseState());
    }).catchError((error){
      print(error.toString());
    });
  }

  Future<void> insertToDatabase(String title, String date,String time) async {
    database!.transaction((txn) {
      return txn.rawInsert("INSERT INTO tasks(title,date,time,status)VALUES('$title','$date','$time','New')"
      ).then((value) {
        print("$value inserted successfully");
        selectFromDatabase(database!);
        emit(InsertIntoDatabaseState());
      }).catchError((error){
        print(error.toString());
      });
    });
  }

  void selectFromDatabase(Database database){
    database.rawQuery("SELECT * FROM tasks").then((value) {
      newTasks= [];
      doneTasks= [];
      archiveTasks= [];
      value.forEach((element) {
        if(element["status"]=="New"){
          newTasks.add(element);
        }else if(element["status"]=="Archive"){
          archiveTasks.add(element);
        }else{
          doneTasks.add(element);
        }
      });
      emit(SelectFormDatabaseState());
    }).catchError((error){
      print(error.toString());
    });
  }

  void updateDatabase({required String status, required int id}) {
    database!.rawUpdate("UPDATE tasks SET status=? WHERE id=?", [status,id]).
    then((value) {
      selectFromDatabase(database!);
      print("raw number $value update");
    }).catchError((error){print (error.toString());});
  }

  void deleteFromDatabase(int id){
    database!.rawDelete("DELETE FROM tasks WHERE id=?",[id]).then((value)  {
      print("$value raw deleted");
      selectFromDatabase(database!);
    }).catchError((error){
      print(error.toString());
    });
  }

}