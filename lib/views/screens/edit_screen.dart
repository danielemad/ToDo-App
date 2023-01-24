import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/views/components.dart';
import "package:todo_app/models/task.dart";
import "package:get/get.dart";

class EditScreen extends StatefulWidget
{
  final Task userTask;
  const EditScreen(this.userTask , {super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();

  late DateTime selectedDate;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
    // List of items in our dropdown menu
  final reminders = <String>[
    "5 minutes early",
    "10 minutes early",
    "15 minutes early",
    "20 minutes early",
  ];


  @override
  void initState() {
    super.initState();
    titleController.text = widget.userTask.title;
    descController.text = widget.userTask.desc;
    dateController.text = widget.userTask.taskDate;
    startTimeController.text = widget.userTask.startTime;
    endTimeController.text = widget.userTask.endTime;
    reminderController.text = widget.userTask.taskReminder;
    selectedDate = DateFormat('yyyy-MM-dd').parse(widget.userTask.taskDate);
    startTime = TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(widget.userTask.startTime));
    endTime = TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(widget.userTask.endTime));
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: myAppBar(title: "Edit Task Screen"),
      body:Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.grey,
              Colors.blueGrey
            ]
          )
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal:24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Editing A Task Form",
                style:TextStyle(
                  fontSize:32,
                  fontWeight: FontWeight.w700
                )
              ),
              const SizedBox(height:16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    myTextFormField(
                      controller: titleController,
                      label:"Task Title",
                      hintText: "Enter Some Text Here",
                      isTextArea: false
                    ),
                    const SizedBox(height:18),
                    myTextFormField(
                      controller: descController,
                      hintText: "Descripe Your Task Here",
                      isTextArea: true
                    ),
                    const SizedBox(height:18),
                    myTextFormField(
                      readOnly: true,
                      controller: dateController,
                      label: "Task Date",
                      suffix: IconButton(
                        onPressed: () async{
              
                          DateTime? pickedDate = await showDatePicker(
                            context: context, 
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30))
                          );
              
                          setState(() {
                            selectedDate = pickedDate ?? selectedDate;
                            dateController.text = DateFormat("yyyy-MM-dd").format(selectedDate);
                          });
              
                        }, 
                        icon:const Icon(
                          Icons.calendar_today_outlined ,
                          color: Colors.black,
                        )
                      )
                    ),
                    const SizedBox(height:18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: myTextFormField(
                            readOnly: true,
                            controller: startTimeController,
                            label: "Start Time",
                            suffix: IconButton(
                              onPressed: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: startTime
                                );
    
                                startTime = time ?? startTime;
                                setState(() => startTimeController.text = startTime.format(context)); 
                        
                              },
                              icon: const Icon(Icons.access_time)
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: myTextFormField(
                            readOnly: true,
                            controller: endTimeController,
                            label: "End Time",
                            suffix: IconButton(
                              onPressed: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: endTime
                                );
                        
                                endTime = time ?? endTime;
                                
                                setState(() => endTimeController.text = endTime.format(context)); 
                        
                              },
                              icon: const Icon(Icons.access_time)
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height:18),
                    myTextFormField(
                      readOnly: true,
                      controller: reminderController,
                      label: "Task Reminder",
                      suffix: Padding(
                        padding: const EdgeInsets.only(right:8),
                        child: DropdownButton(
                          underline: const SizedBox(),
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down , color: Colors.black, ), 
                          
                          // Array list of items
                          items: reminders.map((String reminder) {
                            return DropdownMenuItem(
                              value: reminder,
                              child: Text(reminder),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              reminderController.text = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height:16),
                    ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          
                          Get.find<TaskController>().updateTask(
                            widget.userTask.taskId!,
                            Task(
                              title: titleController.text,
                              desc: descController.text,
                              userId: 1,
                              isDone: widget.userTask.isDone,
                              taskDate: dateController.text,
                              //creationTime: widget.userTask.creationTime ,
                              taskReminder: reminderController.text,
                              startTime: startTimeController.text,
                              endTime: endTimeController.text,
                            )
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            mySnackBar("data is updated successfully")
                          );
        
                          Get.back();
                        }
                      },
                      child: const Text('Submit'),
                    )
                  ],
                ),
              ),
                  
            ],
          ),
        ),
      )
    );
  }
}