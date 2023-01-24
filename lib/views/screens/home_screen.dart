import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import "package:get/get.dart";
import 'package:todo_app/services/notification_service.dart';
import '../../controllers/task_controller.dart';
import '../components.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var selectedDate = DateTime.now();
  final taskController = Get.put<TaskController>(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: "Home Screen",
        actions: <Widget>[
          IconButton(
            onPressed: (){
            
            },
            icon: const Icon(Icons.wb_sunny)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DatePicker(
              DateTime.now(),
              initialSelectedDate:selectedDate,
              selectionColor: Colors.black,
              selectedTextColor: Colors.white,
              daysCount: 30,
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            
            FutureBuilder<void>(
              future: taskController.getAllTasks(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }else{
                  return Obx(
                    () => Column(
                      children: taskController.tasks.where(
                          (task) => task.taskDate == DateFormat("yyyy-MM-dd").format(selectedDate)
                        ).map(
                          (task) => TaskTile(task)
                        ).toList()
                      
                    )
                  );
                }

              }
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(AddTaskScreen(selectedDate));
        },
        child:const Icon(Icons.add),
      ),
    );
  }
}
