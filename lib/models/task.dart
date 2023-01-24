class Task {

  String title, 
         desc, 
         taskDate, 
        // creationTime , 
         startTime,
         endTime ,
         taskReminder;
  int isDone , userId;
  int? taskId;

  Task({
    this.taskId,
    required this.userId,
    required this.title,
    required this.desc,
    required this.taskDate,
    required this.taskReminder,
    //required this.creationTime,
    required this.startTime,
    required this.endTime,
    required this.isDone
  });

/*
    "CREATE TABLE Task (taskId INTEGER PRIMARY KEY AUTOINCREMENT,"
    "title STRING,"
    "desc TEXT,"
    "taskDate STRING,"
    "startTime STRING,"
    "endTime STRING,"
    "isDone INTEGER,"
    "taskReminder String,"
    "userId INTEGER)"
*/

  Map<String , dynamic> toMap() => {
    "taskId": taskId,
    "title":title,
    "desc":desc,
    "taskDate":taskDate,
    //"creationTime":creationTime,
    "startTime":startTime,
    "endTime":endTime,
    "isDone":isDone,
    "taskReminder":taskReminder,
    "userId":userId,
  };

  static Task fromMap(json) =>
  Task(
    taskId: json["taskId"],
    title: json["title"],
    desc: json["desc"],
    userId: json["userId"],
    isDone: json["isDone"],
    taskDate: json["taskDate"],
    taskReminder: json["taskReminder"],
    //creationTime: json["creationTime"],
    startTime: json["startTime"],
    endTime: json["endTime"],
  );

}
