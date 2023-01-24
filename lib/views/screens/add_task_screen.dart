import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:intl/intl.dart';
import 'package:todo_app/services/notification_service.dart';
import '../../controllers/task_controller.dart';
import '../components.dart';
import "../../models/task.dart";

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen(this.calenderTimeLineDate, {super.key});

  final DateTime calenderTimeLineDate;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final TextEditingController reminderController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // List of items in our dropdown menu
  final reminders = <String>[
    "5 minutes early",
    "10 minutes early",
    "15 minutes early",
    "20 minutes early",
  ];

  late DateTime selectedDate;
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hello from init");
    selectedDate = widget.calenderTimeLineDate;
    dateController.text = DateFormat("yyyy-MM-dd").format(selectedDate);
    startTime = TimeOfDay.fromDateTime(selectedDate);
    endTime =
        TimeOfDay.fromDateTime(selectedDate.add(const Duration(minutes: 15)));
    reminderController.text = reminders[0];
  }

  @override
  Widget build(BuildContext context) {
    startTimeController.text = startTime.format(context);
    endTimeController.text = endTime.format(context);
    return Scaffold(
        appBar: myAppBar(title: "Add Task Screen"),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.grey, Colors.blueGrey])),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Adding A Task Form",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      myTextFormField(
                          controller: titleController,
                          label: "Task Title",
                          hintText: "Enter Some Text Here",
                          isTextArea: false),
                      const SizedBox(height: 18),
                      myTextFormField(
                          controller: descController,
                          hintText: "Descripe Your Task Here",
                          isTextArea: true),
                      const SizedBox(height: 18),
                      myTextFormField(
                          readOnly: true,
                          controller: dateController,
                          label: "Task Date",
                          suffix: IconButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 30)));

                                setState(() {
                                  selectedDate = pickedDate ?? selectedDate;
                                  dateController.text = DateFormat("yyyy-MM-dd")
                                      .format(selectedDate);
                                });
                              },
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ))),
                      const SizedBox(height: 18),
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
                                        initialTime: startTime);

                                    startTime = time ?? startTime;

                                    setState(() => startTimeController.text =
                                        startTime.format(context));
                                  },
                                  icon: const Icon(Icons.access_time)),
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
                                        context: context, initialTime: endTime);

                                    endTime = time ?? endTime;

                                    setState(() => endTimeController.text =
                                        endTime.format(context));
                                  },
                                  icon: const Icon(Icons.access_time)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      myTextFormField(
                        readOnly: true,
                        controller: reminderController,
                        label: "Task Reminder",
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            // Down Arrow Icon
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),

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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime startDateTime =
                              DateFormat("yyyy-MM-dd hh:mm a").parse(
                                  "${dateController.text} ${startTimeController.text}");
                          DateTime endDateTime =
                              DateFormat("yyyy-MM-dd hh:mm a").parse(
                                  "${dateController.text} ${endTimeController.text}");
                          startDateTime = startDateTime
                              .subtract(const Duration(minutes: 5));
                          print(startDateTime);

                          if (_formKey.currentState!.validate() &&
                              _isValidTimeRange(startDateTime, endDateTime)) {
                            int taskId = await Get.find<TaskController>()
                                .addTask(Task(
                                    title: titleController.text,
                                    desc: descController.text,
                                    userId: 1,
                                    isDone: 0,
                                    taskDate: dateController.text,
                                    taskReminder: reminderController.text,
                                    startTime: startTimeController.text,
                                    endTime: endTimeController.text
                                    //creationTime: DateFormat("hh:mm a").format(DateTime.now()),
                                    ));

                            ScaffoldMessenger.of(context).showSnackBar(
                                mySnackBar("data is added successfully"));
                            NotificationService.scheduleNotification(
                                id: taskId,
                                title: titleController.text,
                                body: "5 mintues before doing this task",
                                reminderDate: startDateTime);
                            Get.back();

                            // NotificationService.scheduleNotification(
                            //   id: taskId,
                            //   title: titleController.text,
                            //   body: "you got ${startTimeController.text} before doing this task",
                            //   reminderDate:
                            // );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                mySnackBar("choose valid time range"));
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
        ));
  }

  bool _isValidTimeRange(DateTime startDateTime, DateTime endDateTime) {
    var realStartDateTime = startDateTime.add(const Duration(minutes: 5));
    DateTime currentDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute);

    print("current datetime $currentDateTime");
    print("reminder datetime $startDateTime");

    if (startDateTime.isAfter(currentDateTime) &&
        endDateTime.isAfter(realStartDateTime)) {
      return true;
    } else {
      return false;
    }
  }
}
