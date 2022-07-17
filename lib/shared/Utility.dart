import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/cubit/cubit%202.dart';
import 'package:todo_app/shared/colors.dart';
import 'package:todo_app/shared/styles.dart';

class Utility{
  static Widget taskItem({
    required Map<String,dynamic> task,
    required BuildContext context,
  })=>Dismissible(
    key: Key(task["id"].toString()),
    onDismissed: (direction)
    {
      ToDoAppCubit.get(context).deleteFromDatabase(task["id"]);
    },

    background: Container(
      color:Colors.red,
    ),

    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.mainColor,
            child: Text(task["id"].toString(),style: MyStyles.headerStyle,),
            radius: 40,
          ),
          const SizedBox(width: 20,),
          Expanded(
            flex: 5,
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task["title"],style:MyStyles.headerStyle,),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Text(task["date"],style:MyStyles.subtitleStyle,),
                  const SizedBox(width: 15,),
                  Text(task["time"],style:MyStyles.subtitleStyle,),

                ],
              ),
            ],
          ),),
          Expanded(
            flex:1,
              child: IconButton(
                onPressed: (){
                  print(task["id"]);
                  ToDoAppCubit.get(context).updateDatabase(
                      status: "Archive",
                      id: task["id"],
                  );
                },
                icon: const Icon(Icons.archive_outlined,size:20)),
          ),
          Expanded(
            flex: 1,
              child: IconButton(
                onPressed: (){
                  print(task["id"]);
                  ToDoAppCubit.get(context).updateDatabase(
                    status: "Done",
                    id: task["id"],
                  );
                },
                icon: const Icon(Icons.verified_outlined,size:20),)
          ),
        ],
      ),
    ),
  );


  static Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onChange,
  String? Function(String?)? validator,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  void Function()? suffixPressed,
  void Function()? onTap,
  bool enabled = true,
  bool readOnly = false,
  }) =>
      TextFormField(
        cursorRadius: const Radius.circular(10.0),
       // validator: validator,
        textInputAction: TextInputAction.next,
        readOnly: readOnly,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        onChanged: onChange,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(
            prefix,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                icon: Icon(suffix),
            onPressed: suffixPressed!,) : null,
        ),
      );

  /*
   static Widget myButton({
    required Color color,
    required double radius,
    required double width,
    required double height,
    required void Function()? onTap,
    Icon? icon,
    Text? text,
  })=>GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      width:width ,
      height: height,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const SizedBox(),
          text ?? const SizedBox(),
        ],
      ),
    ),
  );
   */
}
