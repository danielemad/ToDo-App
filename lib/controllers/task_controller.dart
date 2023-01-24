import "package:get/get.dart";
import 'package:todo_app/db/db_helper.dart';
import "package:todo_app/models/task.dart";

class TaskController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;

  int get tasksLength => tasks.length;

  void taskWithIdIsDone(int taskId) async
  {
    await DBHelper.db!.rawUpdate(
    """
      UPDATE Task SET isDone = 1
      WHERE taskId = ?
    """,
    [taskId]
    );

    getAllTasks();
  }

  Future<void> getAllTasks() async {
    List<Map<String , dynamic>> tasksAsjson = await DBHelper.db!.query("Task");
    tasks.assignAll(tasksAsjson.map((taskAsJson) => Task.fromMap(taskAsJson)));
    //_tasks.where((task) => task.creationDate == date).toList();
  }

  // add task to certain date
  Future<int> addTask(Task newTask) async{
    int taskId = await DBHelper.db!.insert("Task" , newTask.toMap());
    getAllTasks();

    return taskId;
  }

  // get task with an id
  Task getTaskWithId(int taskId) => 
    tasks.firstWhere((task) => task.taskId == taskId); 

  // edit or update a task with id
  Future<void> updateTask(int taskId, Task newTask) async{
    await DBHelper.db!.rawUpdate(
    """
      UPDATE Task SET title = ? ,
      desc = ? ,
      taskDate = ?,
      startTime = ?,
      endTime = ?,
      taskReminder = ?
      WHERE taskId = ?
    """,
    [ 
      newTask.title , 
      newTask.desc ,
      newTask.taskDate ,
      newTask.startTime, 
      newTask.endTime,
      newTask.taskReminder ,
      taskId
    ]
    );
    getAllTasks();
  }

  // delete task with id
  Future<void> deleteTask(int taskId) async{
    await DBHelper.db!.delete("Task", where: "taskId = ?", whereArgs:[taskId]);
    getAllTasks();
  }
}
