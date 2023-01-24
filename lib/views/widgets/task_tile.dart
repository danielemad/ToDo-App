import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import "package:get/get.dart";
import 'package:todo_app/views/screens/edit_screen.dart';

class TaskTile extends StatelessWidget {

  final Task userTask;

  const TaskTile(this.userTask,{super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16 , vertical: 8),
      child: Slidable(
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const BehindMotion(),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (_){
                Get.find<TaskController>().deleteTask(userTask.taskId!);
              },
              backgroundColor:const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (_){
                  Get.to(
                    EditScreen(
                    Get.find<TaskController>().getTaskWithId(userTask.taskId!)
                  )
                );
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        
        child: ListTile(
          tileColor: Colors.cyan,
            leading:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                  Icon(Icons.info),
              ],
            ),
            title:Text(userTask.title),
            subtitle: Text(userTask.taskDate),
            trailing: userTask.isDone == 1 ? const Text("done") : ElevatedButton(
              onPressed: (){
              Get.find<TaskController>().taskWithIdIsDone(userTask.taskId!);
              },
              child: const Text("done ?"),
            ),
            /*Container(
            color: Colors.cyan,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(userTask.title),
                    const SizedBox(height:8),
                    Text(userTask.creationTime),
                    const SizedBox(height:8),
                    Text(userTask.creationDate)
                  ],
                ),
        
                userTask.isDone == 1 ?
                const Text("done"):
                ElevatedButton(
                  onPressed: () {
                    Get.find<TaskController>().taskWithIdIsDone(userTask.taskId!);
                  },
                  child:const Text("Done ?") ,
                )
              ],
            )
          ),*/
        ),
      )
    );
  }
}
