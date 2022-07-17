import 'package:flutter/material.dart';
import 'package:todo_app/shared/Utility.dart';
import 'package:todo_app/shared/styles.dart';

class DoneTasksScreen extends StatelessWidget {
  List<Map<String,dynamic>> tasks;

  DoneTasksScreen({
    required this.tasks,

  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder:(context, index) => Utility.taskItem(
                  task: tasks[index],
                  context: context
              ),
              separatorBuilder: (context,index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 2,
                  color: Colors.black,
                ),
              ),
              itemCount:tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}